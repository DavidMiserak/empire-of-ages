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
//
// Sprites: Medieval-age units (warrior / archer / lancer — names matched to
// the Tiny Swords sprite folders) render as SpriteAnimationComponents (Blue
// faction for player, Red for enemy, mirrored on enemy side so they face
// left toward the player). Stone-age units (clubman / slinger / dino_rider)
// keep the colored-rectangle fallback — Tiny Swords has no prehistoric
// sprites.

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'age_of_war_game.dart';
import 'base.dart';
import 'unit_def.dart';

/// Spritesheet layout for a Medieval unit.
class _SpriteCfg {
  /// Folder name under tiny_swords/units/{faction}/ — also the spritesheet
  /// family (warrior, archer, lancer).
  final String prefix;
  /// Source frame size (square). Warrior + Archer = 192, Lancer = 320.
  final double frameSize;
  final int runFrames;
  final int attackFrames;
  /// Render size in world units (the sprite is scaled down from its
  /// source frame size). Bigger for Lancer because it includes a mount.
  final double renderSize;
  const _SpriteCfg({
    required this.prefix,
    required this.frameSize,
    required this.runFrames,
    required this.attackFrames,
    required this.renderSize,
  });
}

const _spriteConfigs = <String, _SpriteCfg>{
  'warrior': _SpriteCfg(prefix: 'warrior', frameSize: 192, runFrames: 6, attackFrames: 4, renderSize: 96),
  'archer':  _SpriteCfg(prefix: 'archer',  frameSize: 192, runFrames: 4, attackFrames: 8, renderSize: 96),
  'lancer':  _SpriteCfg(prefix: 'lancer',  frameSize: 320, runFrames: 6, attackFrames: 3, renderSize: 128),
};

class Unit extends PositionComponent with HasGameReference<AgeOfWarGame> {
  final UnitDef def;
  final Side side;
  int hp;

  double _timeSinceAttack = 0.0;
  PositionComponent? _target;

  // Body — exactly one of these is non-null depending on whether this unit
  // has a Tiny Swords sprite (Medieval roster) or falls back to the
  // colored-rectangle placeholder (Stone Age roster).
  SpriteAnimationComponent? _spriteBody;
  SpriteAnimation? _runAnim;
  SpriteAnimation? _attackAnim;
  bool _animIsAttack = false;

  RectangleComponent? _rectBody;
  Color? _rectBaseColor;

  // Damage flash (game-feel polish)
  double _flashRemaining = 0.0;
  static const double _flashDuration = 0.10;

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
    final cfg = _spriteConfigs[def.id];
    if (cfg != null) {
      await _loadSpriteBody(cfg);
    } else {
      _loadRectBody();
    }
  }

  Future<void> _loadSpriteBody(_SpriteCfg cfg) async {
    final faction = side == Side.player ? 'blue' : 'red';
    final base = 'tiny_swords/units/$faction/${cfg.prefix}';
    final runImage = await game.images.load('$base/run.png');
    final attackImage = await game.images.load('$base/attack.png');

    final sheetRun = SpriteSheet(
      image: runImage,
      srcSize: Vector2.all(cfg.frameSize),
    );
    final sheetAttack = SpriteSheet(
      image: attackImage,
      srcSize: Vector2.all(cfg.frameSize),
    );
    _runAnim = sheetRun.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: cfg.runFrames,
    );
    _attackAnim = sheetAttack.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: cfg.attackFrames,
    );

    _spriteBody = SpriteAnimationComponent(
      animation: _runAnim,
      size: Vector2.all(cfg.renderSize),
      anchor: Anchor.bottomCenter,
      position: Vector2(size.x / 2, size.y),
    );
    // Enemy units face left (toward the player). Mirror horizontally;
    // because anchor is bottomCenter, the sprite remains centred on its
    // anchor point after the flip.
    if (side == Side.enemy) {
      _spriteBody!.scale.x = -1;
    }
    add(_spriteBody!);
  }

  void _loadRectBody() {
    _rectBaseColor = side == Side.player
        ? (def.range != null
            ? const Color(0xFF1565C0)
            : const Color(0xFF388E3C))
        : (def.range != null
            ? const Color(0xFFD32F2F)
            : const Color(0xFFEF6C00));
    _rectBody = RectangleComponent(
      size: size,
      paint: Paint()..color = _rectBaseColor!,
    );
    add(_rectBody!);
  }

  void _setAttackAnim(bool attacking) {
    if (_spriteBody == null) return;
    if (attacking == _animIsAttack) return;
    _spriteBody!.animation = attacking ? _attackAnim : _runAnim;
    _animIsAttack = attacking;
  }

  void _applyFlash(double t) {
    if (_spriteBody != null) {
      _spriteBody!.paint = Paint()
        ..colorFilter = ColorFilter.mode(
          Colors.white.withValues(alpha: t * 0.8),
          BlendMode.srcATop,
        );
    } else if (_rectBody != null && _rectBaseColor != null) {
      _rectBody!.paint.color =
          Color.lerp(_rectBaseColor, Colors.white, t)!;
    }
  }

  void _clearFlash() {
    if (_spriteBody != null && _spriteBody!.paint.colorFilter != null) {
      _spriteBody!.paint = Paint();
    } else if (_rectBody != null && _rectBaseColor != null) {
      _rectBody!.paint.color = _rectBaseColor!;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (hp <= 0) return; // dying handled in _takeDamage

    // Damage-flash decay
    if (_flashRemaining > 0) {
      _flashRemaining = (_flashRemaining - dt).clamp(0.0, _flashDuration);
      final t = _flashRemaining / _flashDuration;
      _applyFlash(t);
      if (_flashRemaining == 0) _clearFlash();
    }

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
      _setAttackAnim(true);
      _timeSinceAttack += dt;
      if (_timeSinceAttack >= _attackCadenceSec) {
        _timeSinceAttack = 0.0;
        _attack(_target!);
      }
    } else {
      _setAttackAnim(false);
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
    _flashRemaining = _flashDuration;
    if (hp == 0) {
      _die(killer: killer);
    }
  }

  void _die({Unit? killer}) {
    if (killer != null) {
      final killerBase =
          killer.side == Side.player ? game.playerBase : game.enemyBase;
      killerBase.grantGold(def.goldReward);
      game.playSound('kill');
      game.playSound('gold');
    }
    removeFromParent();
  }
}
