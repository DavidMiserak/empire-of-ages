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
              const SizedBox(height: 12),
              Text(
                playerLost
                    ? 'The enemy reached your base.'
                    : 'You destroyed the enemy base.',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: game.reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
