// Empire of Ages — HUD overlay
// Flutter widgets rendered via game.overlays (per design D3). State binding is
// ValueListenableBuilder against AgeOfWarGame's notifiers (D4).
//
// Layout:
//
//   ┌──────────────────────────────────────────────────────────────┐
//   │  Gold: 175    Age 1    HP P: 1000 / E: 1000      [Age up]    │  top bar
//   │                                                              │
//   │              (the game canvas underneath)                    │
//   │                                                              │
//   │  [Clubman ]  [Slinger ]  [Dino R. ]                          │  bottom strip
//   │   20 gold    35 gold     75 gold                             │
//   └──────────────────────────────────────────────────────────────┘
//
// Spawn buttons disable when gold < unit.cost (per-unit, surgical).
// Age-up button enables when cumulative gold earned >= next age threshold.

import 'package:flutter/material.dart';

import 'age_of_war_game.dart';
import 'unit_def.dart';

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
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(game: game),
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
          // Gold
          ValueListenableBuilder<int>(
            valueListenable: game.gold,
            builder: (context, gold, _) => _Stat(
              label: '⚡',
              value: '$gold',
              color: const Color(0xFFFFCA28),
            ),
          ),
          const SizedBox(width: 8),
          // Progress toward age-up
          ValueListenableBuilder<int>(
            valueListenable: game.cumulativeGoldEarned,
            builder: (context, earned, _) {
              final next = game.config.ages[game.currentAge.value + 1];
              if (next == null) return const SizedBox.shrink();
              final threshold = next.goldThresholdToAdvance ?? 0;
              return _Stat(
                label: '▲',
                value: '$earned/$threshold',
                color: earned >= threshold
                    ? const Color(0xFF7E57C2)
                    : const Color(0xFFB39DDB),
              );
            },
          ),
          const SizedBox(width: 8),
          // Age name + advance button grouped together
          ValueListenableBuilder<int>(
            valueListenable: game.currentAge,
            builder: (context, age, _) => _Stat(
              label: '',
              value: game.config.ages[age]?.name ?? 'Age $age',
              color: const Color(0xFF80DEEA),
            ),
          ),
          const SizedBox(width: 4),
          _AgeUpButton(game: game),
          const Spacer(),
          // Player HP
          ValueListenableBuilder<int>(
            valueListenable: game.playerBaseHp,
            builder: (context, hp, _) => _Stat(
              label: '🏰',
              value: '$hp',
              color: const Color(0xFF66BB6A),
            ),
          ),
          const SizedBox(width: 8),
          // Enemy HP
          ValueListenableBuilder<int>(
            valueListenable: game.enemyBaseHp,
            builder: (context, hp, _) => _Stat(
              label: '💀',
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
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty)
          Text(label, style: const TextStyle(fontSize: 12)),
        if (label.isNotEmpty) const SizedBox(width: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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

// ---------- Bottom bar (spawn buttons) ----------

class _BottomBar extends StatelessWidget {
  final AgeOfWarGame game;
  const _BottomBar({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        border: const Border(
          top: BorderSide(color: Color(0xFF445566), width: 1),
        ),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: game.currentAge,
        builder: (context, age, _) {
          final units = game.config.units.values
              .where((u) => u.age == age)
              .toList();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final unit in units) _SpawnButton(game: game, def: unit),
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
          onPressed: affordable
              ? () {
                  game.playerBase.spawn(def.id);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF455A64),
            disabledBackgroundColor: const Color(0xFF263238),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                def.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                '${def.cost} gold',
                style: TextStyle(
                  fontSize: 12,
                  color: affordable
                      ? const Color(0xFFFFCA28)
                      : Colors.white38,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
