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
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'base.dart';
import 'game_config.dart';
import 'sound_throttle.dart';
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

  /// SoundThrottle for decision D8 (80ms throttle on identical SFX).
  late final SoundThrottle _soundThrottle = SoundThrottle();

  /// SFX paths to pre-warm before first play (gap B, T13).
  /// Using Toolkit's built-in SFX (assets/sfx/) which work with FlameAudio.
  static const List<String> _sfxToPrewarm = [
    'p1.mp3',    // spawn
    'hash1.mp3', // hit impact
    'kill.mp3',  // unit death (scrap metal)
    'gold.mp3',  // gold earned (new item chime)
    'ageup.mp3', // age advance (legendary upgrade)
  ];

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
    // Anchor to center + position at world midpoint so the viewport is
    // centered on the battlefield on all screen sizes.
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.position =
        Vector2(c.worldWidthPx / 2, c.worldHeightPx / 2);

    // gap B — Pre-warm SFX using a dedicated AudioCache pointed at assets/sfx/.
    // We do NOT replace FlameAudio.audioCache (the global assignment broke the
    // Toolkit's AudioController music by corrupting its shared cache state).
    // Instead we create a local cache just for pre-warming, then point
    // FlameAudio at it only for SFX play calls.
    final sfxCache = AudioCache(prefix: 'assets/sfx/');
    try {
      await sfxCache.loadAll(_sfxToPrewarm);
    } catch (e) {
      debugPrint('Audio pre-warm failed (continuing without SFX): $e');
    }
    FlameAudio.audioCache = sfxCache;

    // Initialize game state from config constants.
    gold.value = c.startingGold;
    cumulativeGoldEarned.value = 0;
    currentAge.value = 1;
    playerBaseHp.value = c.playerBaseHp;
    enemyBaseHp.value = c.enemyBaseHp;

    // Battlefield ground: tile Tiny Swords' side-view grass + stone tiles
    // along the ground line, with a darker earth fill underneath for any
    // gap between the bottom tile row and the world bottom.
    await _buildTerrain(
      worldWidth: c.worldWidthPx,
      worldHeight: c.worldHeightPx,
      groundY: c.groundY,
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

  /// Tile the Tiny Swords terrain across the battlefield. The layout (top
  /// to bottom) is:
  ///   - Grass field background: solid grass-green fill above the surface
  ///     row, so castles + units stand in a connected grass field instead
  ///     of floating against dark sky.
  ///   - Surface tile row (grass-capped): visible grass surface aligns with
  ///     [groundY] so feet plant on the grass.
  ///   - Stone body row (pure stone, no grass cap): gives the ground a
  ///     thicker mound look, not a one-tile-thin strip.
  ///   - Earth fill: dark rectangle covering anything left to the world
  ///     bottom.
  Future<void> _buildTerrain({
    required double worldWidth,
    required double worldHeight,
    required double groundY,
  }) async {
    const tilePx = 64.0;
    // Pixels above groundY where the top tile row begins. The Tiny Swords
    // grass-on-stone tile has its grass in the upper portion of each 64px
    // tile; offsetting up by 24px puts that grass surface at groundY.
    const grassSurfaceOffset = 24.0;
    final topRowY = groundY - grassSurfaceOffset;
    final secondRowY = topRowY + tilePx;

    // Grass green sampled to match the Tiny Swords grass-cap tile, so the
    // background fill and the tile row read as continuous grass.
    const grassGreen = Color(0xFF9DBE3E);

    // Grass field background: covers the whole area above the surface tile
    // row. Priority -20 keeps it behind the tile sprites (-10) and units (0+).
    world.add(RectangleComponent(
      position: Vector2(0, 0),
      size: Vector2(worldWidth, topRowY),
      paint: Paint()..color = grassGreen,
      priority: -20,
    ));

    final tilemap = await images.load('tiny_swords/terrain/tilemap.png');
    final sheet = SpriteSheet(image: tilemap, srcSize: Vector2.all(tilePx));
    // Right-half side-view tiles. (row, column) per SpriteSheet API.
    //   (2, 6) — grass-capped surface tile (top of the grass cluster)
    //   (5, 6) — pure stone wall tile (bottom of the stone cluster)
    // Picking row 5 (not 3 or 4) is important: rows 3-4 still carry grass
    // trim from the grass cluster transition, which renders as an unwanted
    // horizontal "stone trim" line between the surface and body rows.
    final grassTile = sheet.getSprite(2, 6);
    final stoneTile = sheet.getSprite(5, 6);

    final cols = (worldWidth / tilePx).ceil();
    for (var i = 0; i < cols; i++) {
      // Top row: grass-capped surface tile.
      world.add(SpriteComponent(
        sprite: grassTile,
        size: Vector2.all(tilePx),
        position: Vector2(i * tilePx, topRowY),
        priority: -10,
      ));
      // Second row: pure stone body so the ground reads as a solid mound.
      world.add(SpriteComponent(
        sprite: stoneTile,
        size: Vector2.all(tilePx),
        position: Vector2(i * tilePx, secondRowY),
        priority: -10,
      ));
    }
    // Earth fill for the strip below the second tile row (down to world bottom).
    final fillTop = secondRowY + tilePx;
    if (fillTop < worldHeight) {
      world.add(RectangleComponent(
        position: Vector2(0, fillTop),
        size: Vector2(worldWidth, worldHeight - fillTop),
        paint: Paint()..color = const Color(0xFF2A2018),
        priority: -10,
      ));
    }
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

  /// Play an SFX, throttled by decision D8 (80ms). Returns true if the sound
  /// was allowed (not throttled), false if it was dropped.
  // SFX audio context: mixWithOthers so SFX never steals audio focus from the
  // background music player. Without this, every FlameAudio.play() call
  // requests+abandons Android audio focus and interrupts the music.
  static final _sfxContext =
      AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers)
          .build();

  bool playSound(String soundKey) {
    if (!_soundThrottle.allow(soundKey)) return false;
    try {
      FlameAudio.play('$soundKey.mp3', audioContext: _sfxContext);
      return true;
    } catch (e) {
      debugPrint('SFX play failed ($soundKey): $e');
      return false;
    }
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
    playSound('ageup');
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

    // Reset sound throttle state.
    _soundThrottle.reset();

    final c = config.constants;
    gold.value = c.startingGold;
    cumulativeGoldEarned.value = 0;
    currentAge.value = 1;
    playerBaseHp.value = c.playerBaseHp;
    enemyBaseHp.value = c.enemyBaseHp;
    state.value = GameState.playing;
  }
}
