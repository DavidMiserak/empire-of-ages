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

import 'background.dart';
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

    // Add background based on starting age (theme from ages.yaml bgSprite field).
    debugPrint('Loading background for age: ${currentAge.value}');
    _addBackgroundForAge(currentAge.value);

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
    //
    // Note: the Tiny Swords tilemap grass cells (e.g. rows 0-1, cols 0-1)
    // each carry tuft borders on all four sides — they're designed as
    // discrete grass patches, not as a tileable field fill. Tiling them
    // produced a visible grid of tuft borders. A solid grass-green fill
    // reads as a clean continuous field instead.
    const grassGreen = Color(0xFF9DBE3E);

    // Grass field background: covers the whole area above the surface tile
    // row. Priority -20 keeps it behind tile sprites (-10) and units (0+).
    world.add(RectangleComponent(
      position: Vector2(0, 0),
      size: Vector2(worldWidth, topRowY),
      paint: Paint()..color = grassGreen,
      priority: -20,
    ));

    final tilemap = await images.load('tiny_swords/terrain/tilemap.png');
    final sheet = SpriteSheet(image: tilemap, srcSize: Vector2.all(tilePx));
    // Tile coordinates (row, col) per SpriteSheet API.
    //   (2, 6) — grass-capped side-view surface tile (top of the right
    //     cluster's grass section), what feet plant on.
    //   (5, 6) — pure stone wall tile (bottom of the stone cluster). Rows
    //     3-4 still carry grass trim, so row 5 is the first clean stone.
    final grassTile = sheet.getSprite(2, 6);
    final stoneTile = sheet.getSprite(5, 6);

    // Decorative bushes: scattered Tiny Swords bush sprites for foliage
    // detail over the solid green field. Each source sheet is 1024×128
    // with 8 bush variants (128×128 each). We mix two sheets: bushes_1
    // (round bushes) and bushes_4 (small branchy bushes). Bushes render
    // at 64×64 (half scale) so they read as smaller-than-castle foliage.
    // Positions are anchored bottom-center on the bush's y coord so they
    // sit on a clear ground line, not float. y values stay within the
    // grass field area (above the surface tile row at topRowY = ~456).
    // Priority -12 puts them in front of the grass background (-20) but
    // behind the surface tile row (-10).
    const bushSrcPx = 128.0;
    const bushDrawPx = 64.0;
    final bushSheet1Image =
        await images.load('tiny_swords/terrain/decorations/bushes_1.png');
    final bushSheet4Image =
        await images.load('tiny_swords/terrain/decorations/bushes_4.png');
    final bushSheet1 = SpriteSheet(
      image: bushSheet1Image,
      srcSize: Vector2.all(bushSrcPx),
    );
    final bushSheet4 = SpriteSheet(
      image: bushSheet4Image,
      srcSize: Vector2.all(bushSrcPx),
    );

    // (x, y, sheet, variant) — bottom-center anchor at (x, y); variant is
    // the column in the 1-row, 8-column bush sheet (0..7).
    final bushPlacements = <(double, double, SpriteSheet, int)>[
      (90, 220, bushSheet1, 0),
      (260, 350, bushSheet4, 2),
      (380, 180, bushSheet1, 3),
      (530, 410, bushSheet4, 5),
      (650, 240, bushSheet1, 1),
      (820, 380, bushSheet4, 7),
      (910, 200, bushSheet1, 4),
      (1100, 340, bushSheet4, 1),
      (140, 410, bushSheet1, 6),
      (1010, 430, bushSheet4, 4),
    ];

    for (final (bx, by, sheetForBush, variant) in bushPlacements) {
      world.add(SpriteComponent(
        sprite: sheetForBush.getSprite(0, variant),
        size: Vector2.all(bushDrawPx),
        position: Vector2(bx, by),
        anchor: Anchor.bottomCenter,
        priority: -12,
      ));
    }

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

  /// Map bgSprite names (from ages.yaml) to LandscapeTheme and parallax layers.
  /// bgSprite format: "theme_name" (e.g., "mountains", "caves", "sky").
  /// Returns theme + layer indices, or null if not found.
  ({LandscapeTheme theme, List<int> layers})? _getBackgroundTheme(String bgSprite) {
    return switch (bgSprite) {
      'mountains' => (theme: LandscapeTheme.mountains, layers: [1, 3, 5]),
      'hills' => (theme: LandscapeTheme.hills, layers: [1]),
      'caves' => (theme: LandscapeTheme.caves, layers: [2, 4, 6]),
      'clouds' => (theme: LandscapeTheme.clouds, layers: [2, 5, 8]),
      'sky' => (theme: LandscapeTheme.sky, layers: [1, 5, 10]),
      _ => null,
    };
  }

  /// Add background layers for the given age based on its bgSprite.
  void _addBackgroundForAge(int ageId) {
    final ageDef = config.ages[ageId];
    if (ageDef == null) {
      debugPrint('Age $ageId not found in config');
      return;
    }

    debugPrint('Age $ageId bgSprite: ${ageDef.bgSprite}');
    final bg = _getBackgroundTheme(ageDef.bgSprite);
    if (bg == null) {
      debugPrint('No background theme mapping for: ${ageDef.bgSprite}');
      return;
    }

    debugPrint('Adding background system: theme=${bg.theme}, layers=${bg.layers}');
    world.add(BackgroundSystem(
      theme: bg.theme,
      layerIndices: bg.layers,
    ));
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
