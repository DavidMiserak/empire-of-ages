// Empire of Ages — Unit component
// Walking + attacking FSM for player and enemy units. Per design D1, the FSM
// lives directly on Unit (no separate behaviour classes for v1).
//
// FSM (compact):
//   WALKING   — move toward enemy base at def.speed px/s
//               -> pick the closest opposing Unit; if in attack range, switch
//                  to ATTACKING. If no unit but we're in range of the enemy
//                  Base, switch to ATTACKING (target = base).
//   ATTACKING — every _attackCadenceSec, deal def.dmg to the target.
//               Target died/despawned -> back to WALKING.
//
// Gold-on-death (decision H): when a Unit's hp drops to 0, the killer's Base
// receives def.goldReward via Base.grantGold().
//
// Target search is O(n) over all live Units. For v1 (~30 units on screen
// max) this is fine; if perf bites later, switch to a spatial bucket or
// Flame's CollisionDetection.

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'age_of_war_game.dart';
import 'base.dart';
import 'unit_def.dart';

class Unit extends PositionComponent with HasGameReference<AgeOfWarGame> {
  final UnitDef def;
  final Side side;
  int hp;

  double _timeSinceAttack = 0.0;
  PositionComponent? _target;

  /// Seconds between attack ticks. Constant across all units in v1.
  static const double _attackCadenceSec = 0.6;

  /// Pixel distance for melee attack reach (when def.range is null).
  static const double _meleeReachPx = 8.0;

  /// Pixel distance from base centre at which a Unit can hit the base.
  static const double _baseReachPx = 50.0;

  Unit({required this.def, required this.side, required Vector2 position})
      : hp = def.hp,
        super(
          position: position,
          size: Vector2(40, 80),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    // Placeholder colored rectangle. T2 replaces with real spritesheet.
    // Colour encodes side + role: green/blue = player melee/ranged,
    // orange/red = enemy melee/ranged.
    final color = side == Side.player
        ? (def.range != null
            ? const Color(0xFF1565C0)
            : const Color(0xFF388E3C))
        : (def.range != null
            ? const Color(0xFFD32F2F)
            : const Color(0xFFEF6C00));
    add(RectangleComponent(size: size, paint: Paint()..color = color));
    add(
      TextComponent(
        text: def.id,
        anchor: Anchor.topCenter,
        position: Vector2(size.x / 2, -10),
        textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white, fontSize: 9),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (hp <= 0) return; // dying handled in _takeDamage

    // Drop stale target (parent removed = was removed from world; or its hp ≤ 0)
    if (_target != null) {
      if (_target!.parent == null) {
        _target = null;
      } else if (_target is Unit && (_target! as Unit).hp <= 0) {
        _target = null;
      }
    }

    _target ??= _findTarget();

    if (_target != null && _isInRange(_target!)) {
      _timeSinceAttack += dt;
      if (_timeSinceAttack >= _attackCadenceSec) {
        _timeSinceAttack = 0.0;
        _attack(_target!);
      }
    } else {
      final dirSign = side == Side.player ? 1.0 : -1.0;
      position.x += dirSign * def.speed * dt;
    }
  }

  /// Find the closest opposing Unit within attack range, or the opposing
  /// Base if we're close enough.
  PositionComponent? _findTarget() {
    final opposingSide = side == Side.player ? Side.enemy : Side.player;
    final opposingBase =
        side == Side.player ? game.enemyBase : game.playerBase;
    final reach = (def.range ?? _meleeReachPx).toDouble();

    Unit? closest;
    double closestDist = double.infinity;
    for (final c in game.world.children) {
      if (c is Unit && c.side == opposingSide && c.hp > 0) {
        final d = (c.position.x - position.x).abs();
        if (d < closestDist) {
          closest = c;
          closestDist = d;
        }
      }
    }
    if (closest != null && closestDist <= reach) {
      return closest;
    }

    // No unit in range — check if we're at the enemy base
    final baseDist = (opposingBase.position.x - position.x).abs();
    if (baseDist <= _baseReachPx) {
      return opposingBase;
    }
    return null;
  }

  bool _isInRange(PositionComponent target) {
    if (target.parent == null) return false;
    final reach = target is Base
        ? _baseReachPx
        : (def.range ?? _meleeReachPx).toDouble();
    return (target.position.x - position.x).abs() <= reach;
  }

  void _attack(PositionComponent target) {
    if (target is Unit) {
      target._takeDamage(def.dmg, killer: this);
    } else if (target is Base) {
      target.takeDamage(def.dmg);
    }
  }

  void _takeDamage(int amount, {Unit? killer}) {
    hp = (hp - amount).clamp(0, def.hp);
    if (hp == 0) {
      _die(killer: killer);
    }
  }

  void _die({Unit? killer}) {
    if (killer != null) {
      final killerBase =
          killer.side == Side.player ? game.playerBase : game.enemyBase;
      killerBase.grantGold(def.goldReward);
    }
    removeFromParent();
  }
}
