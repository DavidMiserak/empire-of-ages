// Empire of Ages — Base component
// Player base + enemy base, both instances of this class. Per design D1, the
// enemy AI lives on the enemy Base as a manual spawn timer (no separate
// EnemyAI class for v1). The decay curve closes outside-voice gap G.
//
// Responsibilities:
//   - track HP; on damage reaching 0, tell the game to end the match
//   - spawn(unitId): consume gold (player), instantiate Unit, add to world
//   - grantGold(amount): kills-only economy (decision H)
//   - enemy variant: manual tick-based spawn AI with elapsed-time decay
//     (interval *= (1 - decay) every 30s, floor at enemy_spawn_floor_ms)

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'age_of_war_game.dart';
import 'unit.dart';

class Base extends PositionComponent with HasGameReference<AgeOfWarGame> {
  final Side side;
  final int maxHp;
  int hp;

  // Enemy-only spawn AI state.
  double _elapsedMatchSeconds = 0.0;
  double _timeSinceLastSpawn = 0.0;
  double _currentSpawnIntervalSec = 0.0;
  final math.Random _rng = math.Random();

  // Damage flash + HP bar (game-feel polish). The body is now a Tiny Swords
  // castle sprite (Blue for player, Red for enemy); the damage flash drives
  // a brief white tint on the sprite via a ColorEffect.
  late final SpriteComponent _castle;
  late final _HpBar _hpBar;
  double _flashRemaining = 0.0;
  static const double _flashDuration = 0.15;

  /// Castle render size. Sprite source is 320×256 (5:4); rendering at
  /// 160×128 is half-scale and preserves the proportions. The base's own
  /// PositionComponent size keeps the smaller logical footprint that the
  /// attack-reach math (_baseReachPx) was tuned against.
  static final Vector2 _castleSize = Vector2(160, 128);

  Base({required this.side, required Vector2 position, required this.maxHp})
      : hp = maxHp,
        super(
          position: position,
          size: Vector2(80, 200),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    final asset = side == Side.player
        ? 'tiny_swords/buildings/castle_blue.png'
        : 'tiny_swords/buildings/castle_red.png';
    final sprite = await game.loadSprite(asset);
    _castle = SpriteComponent(
      sprite: sprite,
      size: _castleSize,
      // Bottom-centre the castle on the base's bottom-centre so it sits on
      // the ground line regardless of the logical footprint width.
      anchor: Anchor.bottomCenter,
      position: Vector2(size.x / 2, size.y),
    );
    add(_castle);

    // HP bar floats above the castle's top edge.
    _hpBar = _HpBar(owner: this)
      ..position = Vector2(size.x / 2, size.y - _castleSize.y - 6)
      ..anchor = Anchor.bottomCenter;
    add(_hpBar);

    if (side == Side.enemy) {
      _currentSpawnIntervalSec =
          game.config.ages[game.currentAge.value]!.enemySpawnIntervalMs / 1000.0;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (side == Side.enemy && game.state.value == GameState.playing) {
      _elapsedMatchSeconds += dt;
      _timeSinceLastSpawn += dt;
      if (_timeSinceLastSpawn >= _currentSpawnIntervalSec) {
        _enemySpawnTick();
        _timeSinceLastSpawn = 0.0;
        _recomputeSpawnInterval();
      }
    }
    // Damage flash decay — manual tween of the sprite's color filter so we
    // don't allocate an Effect on every hit.
    if (_flashRemaining > 0) {
      _flashRemaining = (_flashRemaining - dt).clamp(0.0, _flashDuration);
      final t = _flashRemaining / _flashDuration;
      _castle.paint = Paint()
        ..colorFilter = ColorFilter.mode(
          Colors.white.withValues(alpha: t * 0.8),
          BlendMode.srcATop,
        );
    } else if (_castle.paint.colorFilter != null) {
      _castle.paint = Paint();
    }
  }

  /// Apply damage. When HP hits 0, fire game.endMatch() so the game freezes.
  void takeDamage(int amount) {
    if (hp == 0) return;
    hp = (hp - amount).clamp(0, maxHp);
    _flashRemaining = _flashDuration;
    game.playSound('hash1'); // hit impact sound (throttled by D8)
    if (side == Side.player) {
      game.playerBaseHp.value = hp;
    } else {
      game.enemyBaseHp.value = hp;
    }
    if (hp == 0) {
      game.endMatch(loser: side);
    }
  }

  /// Spawn a unit by id. Returns false if not affordable (player) or unknown.
  /// Player spawns deduct from current gold; enemy spawns are free in v1.
  bool spawn(String unitId) {
    final def = game.config.units[unitId];
    if (def == null) return false;

    if (side == Side.player) {
      if (game.gold.value < def.cost) return false;
      game.gold.value -= def.cost;
    }

    // Spawn at the outside edge of the base, on the ground line.
    final outsideOffset = side == Side.player ? size.x / 2 : -size.x / 2;
    final spawnPos = Vector2(position.x + outsideOffset, position.y);

    game.world.add(Unit(def: def, side: side, position: spawnPos));
    game.playSound('p1'); // spawn poof (throttled by D8)
    return true;
  }

  /// Credit gold to the player (decision H: kills-only economy).
  /// Enemy gold is not modelled in v1.
  void grantGold(int amount) {
    if (side != Side.player) return;
    game.gold.value += amount;
    game.cumulativeGoldEarned.value += amount;
  }

  /// Enemy spawn AI: pick a random affordable unit from the player's current
  /// age or below, spawn it. Free for the enemy in v1.
  void _enemySpawnTick() {
    final available = game.config.units.values
        .where((u) => u.age <= game.currentAge.value)
        .toList();
    if (available.isEmpty) return;
    final pick = available[_rng.nextInt(available.length)];
    spawn(pick.id);
  }

  /// Recompute spawn interval based on elapsed match time + age config (gap G).
  /// interval = max(initial * (1 - decay)^N, floor)  where N = elapsed/30s
  void _recomputeSpawnInterval() {
    final age = game.config.ages[game.currentAge.value]!;
    final decayCount = (_elapsedMatchSeconds / 30).floor();
    final factor = math.pow(1 - age.enemySpawnDecay, decayCount).toDouble();
    final newMs = age.enemySpawnIntervalMs * factor;
    _currentSpawnIntervalSec =
        (newMs / 1000.0).clamp(age.enemySpawnFloorMs / 1000.0, double.infinity);
  }

  /// Reset HP to max and clear enemy spawn state. Called from
  /// [AgeOfWarGame.reset] on Play Again.
  void reset() {
    hp = maxHp;
    _flashRemaining = 0.0;
    _castle.paint = Paint();
    _elapsedMatchSeconds = 0.0;
    _timeSinceLastSpawn = 0.0;
    if (side == Side.enemy) {
      _currentSpawnIntervalSec =
          game.config.ages[game.currentAge.value]!.enemySpawnIntervalMs / 1000.0;
    }
  }
}

/// HP bar that floats above its owner Base. Width fills the parent Base.
/// Colour shifts green → yellow → red as HP drops. Reads owner.hp every
/// frame — simple and avoids ValueNotifier plumbing inside the FlameGame
/// component tree.
class _HpBar extends PositionComponent {
  final Base owner;
  late final RectangleComponent _bg;
  late final RectangleComponent _fg;
  static const double _hpBarWidth = 80;
  static const double _hpBarHeight = 6;

  _HpBar({required this.owner})
      : super(size: Vector2(_hpBarWidth, _hpBarHeight));

  @override
  Future<void> onLoad() async {
    _bg = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withValues(alpha: 0.55),
    );
    _fg = RectangleComponent(
      size: Vector2(size.x, size.y),
      paint: Paint()..color = const Color(0xFF66BB6A),
    );
    add(_bg);
    add(_fg);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final ratio = (owner.hp / owner.maxHp).clamp(0.0, 1.0);
    _fg.size.x = size.x * ratio;
    // 0..1 → red (0°) → yellow (60°) → green (120°)
    final hue = ratio * 120;
    _fg.paint.color = HSVColor.fromAHSV(1.0, hue, 0.65, 0.85).toColor();
  }
}
