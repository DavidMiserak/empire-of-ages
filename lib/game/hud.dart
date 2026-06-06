// Empire of Ages — HUD overlay
// Flutter widgets rendered via game.overlays (per design D3). State binding is
// ValueListenableBuilder against AgeOfWarGame's notifiers (D4).
//
// Layout:
//
//   ┌──────────────────────────────────────────────────────────────┐
//   │  🪙 175  📈 0/300  [STONE AGE] [▲ Medieval]   🏰 1000  ☠ 1000│  top bar
//   │                                                              │
//   │                       (battlefield)                          │
//   │                                                              │
//   │  [W][A][L]                                  (clear)          │  spawn panel
//   │  [castle]                              [enemy castle]        │
//   └──────────────────────────────────────────────────────────────┘
// (back-to-level-select arrow lives in PlaySessionScreen, not here.)
//
// Spawn buttons disable when gold < unit.cost (per-unit, surgical).
// Age-up button enables when cumulative gold earned >= next age threshold.

import 'package:flutter/material.dart';

import 'age_of_war_game.dart';
import 'unit_def.dart';

/// Tiny Swords gold coin sprite — replaces the Material bolt icon (decision:
/// "lightning bolt for gold is confusing").
const _goldAsset = 'assets/images/tiny_swords/resources/gold.png';

/// Small inline coin widget. Used in the HUD stat row and in spawn buttons
/// so the currency reads identically wherever it appears.
class _Coin extends StatelessWidget {
  final double size;
  final bool dimmed;
  const _Coin({this.size = 18, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _goldAsset,
      width: size,
      height: size,
      filterQuality: FilterQuality.none, // preserve pixel-art edges
      opacity: dimmed ? const AlwaysStoppedAnimation(0.4) : null,
    );
  }
}

class Hud extends StatelessWidget {
  final AgeOfWarGame game;
  const Hud({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    // While the game is still loading config, show a minimal placeholder so
    // the HUD doesn't crash trying to read game.config.
    return ValueListenableBuilder<GameState>(
      valueListenable: game.state,
      builder: (context, state, _) {
        if (state == GameState.loading) {
          return const _LoadingHud();
        }
        return SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TopBar(game: game),
              ),
              // Spawn buttons floated above the player castle's roof so the
              // bottom of the battlefield (grass strip + castle silhouette)
              // stays visible. Bottom anchor 165dp clears the castle's top
              // edge on the reference landscape phone (~384dp tall logical).
              // The back-to-level-select affordance lives in the surrounding
              // PlaySessionScreen, not here, so we don't double it up.
              Positioned(
                bottom: 165,
                left: 12,
                child: _SpawnPanel(game: game),
              ),
              // Game-over UI lives in the separate 'gameOver' overlay
              // (registered in lib/play_session/game_widget.dart), not here.
            ],
          ),
        );
      },
    );
  }
}

// ---------- Loading ----------

class _LoadingHud extends StatelessWidget {
  const _LoadingHud();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Loading…',
        style: TextStyle(color: Colors.white70, fontSize: 18),
      ),
    );
  }
}

// ---------- Top bar (gold / age / HP / age-up) ----------

class _TopBar extends StatelessWidget {
  final AgeOfWarGame game;
  const _TopBar({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF445566), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Gold — Tiny Swords coin sprite, matched in colour to the value text.
          ValueListenableBuilder<int>(
            valueListenable: game.gold,
            builder: (context, gold, _) => _Stat(
              leading: const _Coin(size: 20),
              value: '$gold',
              color: const Color(0xFFFFCA28),
            ),
          ),
          const SizedBox(width: 12),
          // Progress toward age-up
          ValueListenableBuilder<int>(
            valueListenable: game.cumulativeGoldEarned,
            builder: (context, earned, _) {
              final next = game.config.ages[game.currentAge.value + 1];
              if (next == null) return const SizedBox.shrink();
              final threshold = next.goldThresholdToAdvance ?? 0;
              return _Stat(
                leading: Icon(
                  Icons.trending_up,
                  size: 18,
                  color: earned >= threshold
                      ? const Color(0xFF7E57C2)
                      : const Color(0xFFB39DDB),
                ),
                value: '$earned/$threshold',
                color: earned >= threshold
                    ? const Color(0xFF7E57C2)
                    : const Color(0xFFB39DDB),
              );
            },
          ),
          const SizedBox(width: 12),
          // Age name styled as a chapter chip, not a stat — it's a context
          // label, not a number.
          ValueListenableBuilder<int>(
            valueListenable: game.currentAge,
            builder: (context, age, _) => _AgeChip(
              name: game.config.ages[age]?.name ?? 'Age $age',
            ),
          ),
          const SizedBox(width: 6),
          _AgeUpButton(game: game),
          const Spacer(),
          // Player HP
          ValueListenableBuilder<int>(
            valueListenable: game.playerBaseHp,
            builder: (context, hp, _) => _Stat(
              leading: const Icon(Icons.castle, size: 18, color: Color(0xFF66BB6A)),
              value: '$hp',
              color: const Color(0xFF66BB6A),
            ),
          ),
          const SizedBox(width: 12),
          // Enemy HP
          ValueListenableBuilder<int>(
            valueListenable: game.enemyBaseHp,
            builder: (context, hp, _) => _Stat(
              leading: const Icon(Icons.dangerous, size: 18, color: Color(0xFFEF5350)),
              value: '$hp',
              color: const Color(0xFFEF5350),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  /// Leading icon widget — kept generic so the gold stat can use the
  /// pixel-art Tiny Swords coin while HP and progress use Material icons.
  final Widget leading;
  final String value;
  final Color color;
  const _Stat({required this.leading, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading,
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            // tabular-nums keeps numbers from jittering as values change
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// Age name shown as a chapter-style chip — visually distinct from the
/// adjacent numeric stats so the eye reads it as context, not data.
class _AgeChip extends StatelessWidget {
  final String name;
  const _AgeChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2638),
        border: Border.all(color: const Color(0xFF80DEEA), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        name.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF80DEEA),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _AgeUpButton extends StatelessWidget {
  final AgeOfWarGame game;
  const _AgeUpButton({required this.game});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.currentAge,
      builder: (context, age, _) {
        final next = game.config.ages[age + 1];
        if (next == null) {
          return const _DisabledChip(label: 'Max age');
        }
        final threshold = next.goldThresholdToAdvance ?? 0;
        return ValueListenableBuilder<int>(
          valueListenable: game.cumulativeGoldEarned,
          builder: (context, cumulative, _) {
            final ready = cumulative >= threshold;
            return ElevatedButton(
              onPressed: ready ? game.ageUp : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7E57C2),
                disabledBackgroundColor: const Color(0xFF424242),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              child: Text(ready ? '▲ ${next.name}' : '▲ ${next.name}'),
            );
          },
        );
      },
    );
  }
}

class _DisabledChip extends StatelessWidget {
  final String label;
  const _DisabledChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}

// ---------- Spawn panel (floats above the player castle) ----------

class _SpawnPanel extends StatelessWidget {
  final AgeOfWarGame game;
  const _SpawnPanel({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF445566), width: 1),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: game.currentAge,
        builder: (context, age, _) {
          final units = game.config.units.values
              .where((u) => u.age == age)
              .toList();
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < units.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                _SpawnButton(game: game, def: units[i]),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SpawnButton extends StatelessWidget {
  final AgeOfWarGame game;
  final UnitDef def;
  const _SpawnButton({required this.game, required this.def});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: game.gold,
      builder: (context, gold, _) {
        final affordable = gold >= def.cost;
        return ElevatedButton(
          onPressed: affordable ? () => game.playerBase.spawn(def.id) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF455A64),
            disabledBackgroundColor: const Color(0xFF263238),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white38,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                def.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Coin(size: 12, dimmed: !affordable),
                  const SizedBox(width: 2),
                  Text(
                    '${def.cost}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: affordable
                          ? const Color(0xFFFFCA28)
                          : Colors.white38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
