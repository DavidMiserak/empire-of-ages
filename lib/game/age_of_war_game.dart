// Empire of Ages — main FlameGame class
// Bootstraps the world: loads GameConfig once (D5), sets up a fixed-resolution
// camera matching world dimensions (gap D), pre-warms the audio cache (gap B),
// and exposes ValueNotifiers the HUD will bind to (D4).
//
// T6 deliberately ships only the skeleton. Subsequent tasks fill in:
//   T7  — Base component + enemy spawn Timer with decay (gap G)
//   T8  — Unit component (walk + attack FSM)
//   T9  — HUD overlay (ValueListenableBuilder over the notifiers below)
//   T10 — ageUp() effect implementation
//   T11 — game-over flow + reset() clears 'gameOver' overlay (gap C)
//   T12 — WidgetsBindingObserver + pauseEngine/resumeEngine (gap F)
//   T13 — SoundThrottle wiring (decision D8)

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'game_config.dart';

/// Top-level game state. update() short-circuits when state is `over`
/// (decision D6).
enum GameState { loading, playing, over }

class AgeOfWarGame extends FlameGame {
  /// Loaded once in [onLoad] (D5). Throws ConfigLoadError fail-loud if YAML
  /// is missing or malformed.
  late final GameConfig config;

  // ---- Reactive state (D4) ----
  // HUD widgets bind to these via ValueListenableBuilder. Surgical rebuilds.
  final ValueNotifier<int> gold = ValueNotifier<int>(0);
  final ValueNotifier<int> currentAge = ValueNotifier<int>(1);
  final ValueNotifier<int> cumulativeGoldEarned = ValueNotifier<int>(0);
  final ValueNotifier<int> playerBaseHp = ValueNotifier<int>(0);
  final ValueNotifier<int> enemyBaseHp = ValueNotifier<int>(0);
  final ValueNotifier<GameState> state =
      ValueNotifier<GameState>(GameState.loading);

  /// SFX paths to pre-warm before first play (gap B).
  /// T13 populates this from the unit catalog. Empty in T6.
  static const List<String> _sfxToPrewarm = <String>[];

  @override
  Color backgroundColor() => const Color(0xFF1a2638); // dusk sky

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // D5: parse YAML once, cache forever.
    config = await GameConfig.load();
    final c = config.constants;

    // D — Fixed-resolution camera matching world dimensions from ages.yaml.
    // Age of War never scrolls; the world is a fixed-size canvas that letterboxes
    // to whatever screen it lands on.
    camera = CameraComponent.withFixedResolution(
      width: c.worldWidthPx,
      height: c.worldHeightPx,
    );

    // B — Pre-warm the FlameAudio cache to kill 100–300ms first-play latency on
    // Android. No-op when the list is empty (T6). Wrapped so a missing asset
    // doesn't kill the game — log + continue, game stays playable without SFX
    // (eng-review failure-modes table: AgeOfWarGame.onLoad critical gap).
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

    // T6 placeholder world content: a ground line so you can see the camera
    // resolved correctly. T7 replaces this with the real battlefield.
    world.add(
      RectangleComponent(
        position: Vector2(0, c.groundY),
        size: Vector2(c.worldWidthPx, c.worldHeightPx - c.groundY),
        paint: Paint()..color = const Color(0xFF4a3826), // earth
      ),
    );

    // Centered debug text confirming the world rendered.
    // Removed when T7 adds Base components.
    world.add(
      TextComponent(
        text: 'Empire of Ages — T6 skeleton (gold: ${gold.value})',
        position: Vector2(c.worldWidthPx / 2, c.groundY - 40),
        anchor: Anchor.bottomCenter,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFEEEEEE),
            fontSize: 18,
          ),
        ),
      ),
    );

    state.value = GameState.playing;
  }

  @override
  void update(double dt) {
    // D6: freeze the simulation when game is over. update() still gets called
    // by Flame; we just skip propagating to child components by short-circuiting
    // before super.update.
    if (state.value == GameState.over) {
      return;
    }
    super.update(dt);
  }

  /// Advance to the next age. Filled in by T10 (flash + sound + sprite swap).
  void ageUp() {
    if (currentAge.value >= config.ages.length) return;
    currentAge.value += 1;
    // T10: trigger screen flash, play age-up sound, swap sprite set on all units.
  }

  /// "Play Again" entry point. Filled in by T11.
  void reset() {
    // gap C: game.reset() does NOT auto-remove overlays. Be explicit.
    overlays.remove('gameOver');

    final c = config.constants;
    gold.value = c.startingGold;
    cumulativeGoldEarned.value = 0;
    currentAge.value = 1;
    playerBaseHp.value = c.playerBaseHp;
    enemyBaseHp.value = c.enemyBaseHp;
    state.value = GameState.playing;
    // T11: remove all spawned Unit components, reset both Bases.
  }
}
