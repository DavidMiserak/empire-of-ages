// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';

// In-game dark-navy sky, reused so the menu doesn't jar-cut from cream-pastel
// to navy on the first tap of Play. See AgeOfWarGame.backgroundColor().
const _bgTop = Color(0xFF1a2638);
const _bgBottom = Color(0xFF0F1722);
const _accent = Color(0xFFFFCA28); // gold — the in-game economy colour
const _ink = Color(0xFFE6ECF5);

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

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
          child: Stack(
            children: [
              // Title + buttons stacked vertically in the centre of the
              // viewport, instead of split left/right (ResponsiveScreen was
              // designed for portrait, which we're not).
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'EMPIRE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 84,
                        height: 1,
                        color: _accent,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'of Ages',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Permanent Marker',
                        fontSize: 36,
                        height: 1,
                        color: _ink,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Survive the ages.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _ink.withValues(alpha: 0.6),
                        fontSize: 14,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 36),
                    _MenuButton(
                      label: 'PLAY',
                      primary: true,
                      onPressed: () {
                        audioController.playSfx(SfxType.buttonTap);
                        GoRouter.of(context).go('/play');
                      },
                    ),
                    const SizedBox(height: 12),
                    _MenuButton(
                      label: 'SETTINGS',
                      primary: false,
                      onPressed: () =>
                          GoRouter.of(context).push('/settings'),
                    ),
                  ],
                ),
              ),

              // Footer: music toggle + credit, anchored bottom-right. Small,
              // muted, doesn't compete with the hero composition.
              Positioned(
                right: 16,
                bottom: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: settingsController.musicOn,
                      builder: (context, musicOn, _) {
                        return IconButton(
                          onPressed: settingsController.toggleMusicOn,
                          icon: Icon(
                            musicOn ? Icons.music_note : Icons.music_off,
                            color: _ink.withValues(alpha: 0.7),
                            size: 20,
                          ),
                          tooltip: musicOn ? 'Music on' : 'Music off',
                          style: IconButton.styleFrom(
                            minimumSize: const Size(40, 40),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Music: Joel Steudler',
                      style: TextStyle(
                        color: _ink.withValues(alpha: 0.5),
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
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

class _MenuButton extends StatelessWidget {
  final String label;
  final bool primary;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.label,
    required this.primary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 52,
      child: primary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: _bgTop,
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: _ink,
                side: BorderSide(color: _ink.withValues(alpha: 0.4)),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(label),
            ),
    );
  }
}
