// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Empire of Ages: hosts the Flame GameWidget rendering AgeOfWarGame. The
// game instance is created and owned by PlaySessionScreen so the HUD widgets
// (TopBar, SpawnSidebar) can share it without an overlay.
// Only 'gameOver' remains as an overlay (modal); TopBar and SpawnSidebar
// are now rendered as proper Flutter widgets in PlaySessionScreen.

import 'package:flame/game.dart' as flame;
import 'package:flutter/material.dart';

import '../game/age_of_war_game.dart';
import '../game/game_over_overlay.dart';

class GameWidget extends StatelessWidget {
  final AgeOfWarGame game;
  const GameWidget({required this.game, super.key});

  @override
  Widget build(BuildContext context) {
    return flame.GameWidget<AgeOfWarGame>(
      game: game,
      overlayBuilderMap: {
        'gameOver': (context, game) => GameOverOverlay(game: game),
      },
    );
  }
}
