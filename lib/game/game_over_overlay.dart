// Empire of Ages — game-over Flutter overlay
// Shown via game.overlays.add('gameOver') from AgeOfWarGame.endMatch() (T11).
// Removed by AgeOfWarGame.reset(), explicitly (gap C — game.reset() does NOT
// clear overlays for you).

import 'package:flutter/material.dart';

import 'age_of_war_game.dart';

class GameOverOverlay extends StatelessWidget {
  final AgeOfWarGame game;
  const GameOverOverlay({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    final playerLost = game.playerBaseHp.value <= 0;
    final outcome = playerLost ? 'DEFEAT' : 'VICTORY';
    final outcomeColor =
        playerLost ? const Color(0xFFEF5350) : const Color(0xFF66BB6A);
    final ageName =
        game.config.ages[game.currentAge.value]?.name ?? 'Age ${game.currentAge.value}';

    // Full-bleed dimming behind the content, SafeArea only on the content
    // so the dim reaches the screen edges but text stays clear of cutouts.
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                outcome,
                style: TextStyle(
                  color: outcomeColor,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                playerLost
                    ? 'The enemy reached your base.'
                    : 'You destroyed the enemy base.',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              _RecapRow(game: game, ageName: ageName),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: game.reset,
                style: ElevatedButton.styleFrom(
                  // Match the menu accent (palette.pen #1d75fb) rather than
                  // the HUD's purple — purple is reserved for the age-up
                  // "ready" signal, so reusing it here muddies the meaning.
                  backgroundColor: const Color(0xFF1d75fb),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                child: const Text('PLAY AGAIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecapRow extends StatelessWidget {
  final AgeOfWarGame game;
  final String ageName;

  const _RecapRow({required this.game, required this.ageName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RecapStat(
          icon: Icons.timeline,
          label: 'Reached',
          value: ageName,
        ),
        const SizedBox(width: 24),
        _RecapStat(
          icon: Icons.bolt,
          label: 'Gold earned',
          value: '${game.cumulativeGoldEarned.value}',
        ),
      ],
    );
  }
}

class _RecapStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RecapStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFFFFCA28)),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
