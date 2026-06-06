// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Choose your battlefield',
                  style: TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
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
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: const Text('Back'),
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
    return ListTile(
      enabled: unlocked,
      onTap: unlocked
          ? () {
              final audioController = context.read<AudioController>();
              audioController.playSfx(SfxType.buttonTap);
              GoRouter.of(context).go('/play/session/${level.number}');
            }
          : null,
      leading: CircleAvatar(
        backgroundColor: unlocked
            ? const Color(0xFF7E57C2)
            : Colors.black26,
        foregroundColor: Colors.white,
        child: unlocked
            ? Text(
                '${level.number}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : const Icon(Icons.lock, size: 18),
      ),
      title: Text(
        'Battle ${level.number}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(
        unlocked
            ? 'Tap to deploy'
            : 'Win Battle ${level.number - 1} to unlock',
      ),
    );
  }
}
