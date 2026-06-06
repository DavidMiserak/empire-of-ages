// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import 'levels.dart';

// Shared dark battle palette (kept in step with the title screen).
const _bgTop = Color(0xFF1a2638);
const _bgBottom = Color(0xFF0F1722);
const _accent = Color(0xFFFFCA28); // gold
const _ink = Color(0xFFE6ECF5);

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_bgTop, _bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => GoRouter.of(context).go('/'),
                      icon: const Icon(Icons.arrow_back, color: _ink),
                      tooltip: 'Back',
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Choose your battlefield',
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 26,
                        color: _ink,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  children: [
                    for (final level in gameLevels)
                      _LevelTile(
                        level: level,
                        unlocked: playerProgress.highestLevelReached >=
                            level.number - 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final GameLevel level;
  final bool unlocked;

  const _LevelTile({required this.level, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    final onTap = unlocked
        ? () {
            final audioController = context.read<AudioController>();
            audioController.playSfx(SfxType.buttonTap);
            GoRouter.of(context).go('/play/session/${level.number}');
          }
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: unlocked
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: unlocked
                      ? _accent
                      : Colors.white.withValues(alpha: 0.08),
                  foregroundColor: unlocked ? _bgTop : _ink.withValues(alpha: 0.4),
                  child: unlocked
                      ? Text(
                          '${level.number}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : const Icon(Icons.lock, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Battle ${level.number}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: unlocked
                              ? _ink
                              : _ink.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unlocked
                            ? 'Tap to deploy'
                            : 'Win Battle ${level.number - 1} to unlock',
                        style: TextStyle(
                          fontSize: 12,
                          color: _ink.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                if (unlocked)
                  Icon(
                    Icons.chevron_right,
                    color: _ink.withValues(alpha: 0.5),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
