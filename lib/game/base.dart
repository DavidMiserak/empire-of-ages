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

  // Damage flash + HP bar (game-feel polish)
  late final RectangleComponent _body;
  late final Color _baseBodyColor;
  late final _HpBar _hpBar;
  double _flashRemaining = 0.0;
  static const double _flashDuration = 0.15;

  Base({required this.side, required Vector2 position, required this.maxHp})
      : hp = maxHp,
        super(
          position: position,
          size: Vector2(80, 200),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    // Placeholder rectangle. T2 will replace with real sprite.
    _baseBodyColor = side == Side.player
        ? const Color(0xFF2E7D32) // green for player
        : const Color(0xFFC62828); // red for enemy
    _body = RectangleComponent(
      size: size,
      paint: Paint()..color = _baseBodyColor,
    );
    add(_body);
    add(
      TextComponent(
        text: side == Side.player ? 'PLAYER' : 'ENEMY',
        anchor: Anchor.bottomCenter,
        position: Vector2(size.x / 2, -8),
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
    // HP bar floats above the text label.
    _hpBar = _HpBar(owner: this)
      ..position = Vector2(size.x / 2, -26)
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
    // Damage flash decay
    if (_flashRemaining > 0) {
      _flashRemaining = (_flashRemaining - dt).clamp(0.0, _flashDuration);
      final t = _flashRemaining / _flashDuration;
      _body.paint.color = Color.lerp(_baseBodyColor, Colors.white, t)!;
    }
  }

  /// Apply damage. When HP hits 0, fire game.endMatch() so the game freezes.
  void takeDamage(int amount) {
    if (hp == 0) return;
    hp = (hp - amount).clamp(0, maxHp);
    _flashRemaining = _flashDuration;
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
    _body.paint.color = _baseBodyColor;
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
