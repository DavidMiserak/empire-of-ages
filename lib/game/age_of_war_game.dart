// Empire of Ages — main FlameGame class
// Bootstraps the world: loads GameConfig once (D5), sets up a fixed-resolution
// camera matching world dimensions (gap D), pre-warms the audio cache (gap B),
// and exposes ValueNotifiers the HUD binds to (D4).
//
// T7 added [Base] components. T8 added [Unit]. T9 added the 'hud' overlay
// (registered in lib/play_session/game_widget.dart so this file stays
// FlameGame-only).
//
// Remaining task hooks:
//   T10 — fill in ageUp() effect (flash + sound + sprite swap)
//   T11 — fill in reset(); add the 'gameOver' overlay; freeze on endMatch
//   T12 — WidgetsBindingObserver + pauseEngine/resumeEngine (gap F)
//   T13 — SoundThrottle wiring on spawn/hit/age-up (decision D8)

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'base.dart';
import 'game_config.dart';
import 'unit.dart';

/// Which side of the battlefield a Base or Unit belongs to.
enum Side { player, enemy }

/// Top-level game state. update() short-circuits when state is `over` (D6).
enum GameState { loading, playing, over }

class AgeOfWarGame extends FlameGame {
  /// Loaded once in [onLoad] (D5). Throws ConfigLoadError fail-loud if YAML
  /// is missing or malformed.
  late final GameConfig config;

  /// Player base, instantiated in [onLoad]. Referenced by Unit FSM for target
  /// resolution and by HUD for HP display.
  late final Base playerBase;

  /// Enemy base, similarly.
  late final Base enemyBase;

  // ---- Reactive state (D4) ----
  // HUD widgets bind via ValueListenableBuilder — surgical rebuilds only when
  // the specific value changes.
  final ValueNotifier<int> gold = ValueNotifier<int>(0);
  final ValueNotifier<int> currentAge = ValueNotifier<int>(1);
  final ValueNotifier<int> cumulativeGoldEarned = ValueNotifier<int>(0);
  final ValueNotifier<int> playerBaseHp = ValueNotifier<int>(0);
  final ValueNotifier<int> enemyBaseHp = ValueNotifier<int>(0);
  final ValueNotifier<GameState> state =
      ValueNotifier<GameState>(GameState.loading);

  /// SFX paths to pre-warm before first play (gap B). T13 populates.
  static const List<String> _sfxToPrewarm = <String>[];

  @override
  Color backgroundColor() => const Color(0xFF1a2638); // dusk sky

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // D5: parse YAML once, cache forever.
    config = await GameConfig.load();
    final c = config.constants;

    // gap D — Fixed-resolution view: the world is a fixed-size canvas
    // (width × height from ages.yaml) and the viewfinder maps it onto
    // whatever screen size we get. We configure the EXISTING camera
    // (FlameGame already created it pointing at `world`) instead of
    // reassigning, which would orphan our world from the new camera.
    camera.viewfinder.visibleGameSize =
        Vector2(c.worldWidthPx, c.worldHeightPx);
    // Centre the visible area on the middle of the world so units near the
    // left/right edges aren't clipped by the auto-fit.
    camera.viewfinder.position =
        Vector2(c.worldWidthPx / 2, c.worldHeightPx / 2);

    // gap B — Pre-warm the FlameAudio cache to kill 100–300ms first-play
    // latency on Android. No-op while the list is empty. Wrapped so a missing
    // asset doesn't kill the game — log + continue (eng-review failure-modes
    // critical gap: audio-asset-missing on onLoad).
    if (_sfxToPrewarm.isNotEmpty) {
      try {
        await FlameAudio.audioCache.loadAll(_sfxToPrewarm);
      } catch (e) {
        debugPrint('Audio pre-warm failed (continuing without SFX): $e');
      }
    }

    // Initialize game state from config constants.
    gold.value = c.startingGold;
    cumulativeGoldEarned.value = 0;
    currentAge.value = 1;
    playerBaseHp.value = c.playerBaseHp;
    enemyBaseHp.value = c.enemyBaseHp;

    // Ground stripe so the camera resolution is visually verifiable.
    world.add(
      RectangleComponent(
        position: Vector2(0, c.groundY),
        size: Vector2(c.worldWidthPx, c.worldHeightPx - c.groundY),
        paint: Paint()..color = const Color(0xFF4a3826), // earth
      ),
    );

    // Two Bases at the world's left/right edges (positions from ages.yaml).
    playerBase = Base(
      side: Side.player,
      position: Vector2(c.playerBaseX, c.groundY),
      maxHp: c.playerBaseHp,
    );
    enemyBase = Base(
      side: Side.enemy,
      position: Vector2(c.enemyBaseX, c.groundY),
      maxHp: c.enemyBaseHp,
    );
    world.addAll([playerBase, enemyBase]);

    state.value = GameState.playing;
  }

  @override
  void update(double dt) {
    // D6: freeze the simulation when game is over. update() still gets called
    // by Flame; we just skip propagating to child components by short-
    // circuiting before super.update.
    if (state.value == GameState.over) {
      return;
    }
    super.update(dt);
  }

  /// Called by [Base.takeDamage] when one Base reaches 0 HP.
  /// Sets state to `over` (D6 freeze) and shows the 'gameOver' overlay
  /// (registered in lib/play_session/game_widget.dart). [reset] is the
  /// inverse — it removes the overlay (explicitly, gap C) and resets state.
  void endMatch({required Side loser}) {
    if (state.value == GameState.over) return; // idempotent
    state.value = GameState.over;
    overlays.add('gameOver');
    debugPrint(
      'Match over: ${loser == Side.player ? "DEFEAT" : "VICTORY"} '
      '(player HP: ${playerBaseHp.value}, enemy HP: ${enemyBaseHp.value})',
    );
  }

  /// Advance to the next age. T10 will add the flash + sound + sprite swap.
  /// Returns true if advanced, false if already at max age or cost not met.
  bool ageUp() {
    final next = currentAge.value + 1;
    final nextAge = config.ages[next];
    if (nextAge == null) return false; // already at max age
    final threshold = nextAge.goldThresholdToAdvance ?? 0;
    if (cumulativeGoldEarned.value < threshold) return false;
    currentAge.value = next;
    return true;
  }

  /// "Play Again" entry point. Restores starting state without remounting the
  /// FlameGame instance.
  void reset() {
    // gap C: game.reset() does NOT auto-remove overlays. Be explicit.
    overlays.remove('gameOver');

    // Despawn every Unit. iterate-via-toList to avoid mutation-during-iteration.
    final units = world.children.whereType<Unit>().toList();
    for (final u in units) {
      u.removeFromParent();
    }

    // Reset both Bases (HP back to max, enemy spawn timer cleared).
    playerBase.reset();
    enemyBase.reset();

    final c = config.constants;
    gold.value = c.startingGold;
    cumulativeGoldEarned.value = 0;
    currentAge.value = 1;
    playerBaseHp.value = c.playerBaseHp;
    enemyBaseHp.value = c.enemyBaseHp;
    state.value = GameState.playing;
  }
}
