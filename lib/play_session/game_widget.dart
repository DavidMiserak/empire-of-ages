// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Empire of Ages: this widget originally hosted the Casual Games Toolkit's
// slider puzzle. T6 swapped it for a Flame GameWidget hosting AgeOfWarGame.
// T9 added the 'hud' overlay via overlayBuilderMap + initialActiveOverlays.

import 'package:flame/game.dart' as flame;
import 'package:flutter/material.dart';

import '../game/age_of_war_game.dart';
import '../game/game_over_overlay.dart';
import '../game/hud.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({super.key});

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  // One game instance per mount. Holding it on State avoids re-loading the
  // YAML config every Flutter rebuild — onLoad runs once when the GameWidget
  // first attaches.
  late final AgeOfWarGame _game = AgeOfWarGame();

  @override
  void dispose() {
    _game.gold.dispose();
    _game.currentAge.dispose();
    _game.cumulativeGoldEarned.dispose();
    _game.playerBaseHp.dispose();
    _game.enemyBaseHp.dispose();
    _game.state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return flame.GameWidget<AgeOfWarGame>(
      game: _game,
      overlayBuilderMap: {
        'hud': (context, game) => Hud(game: game),
        'gameOver': (context, game) => GameOverOverlay(game: game),
      },
      // 'hud' is active from the start; 'gameOver' is added by endMatch and
      // removed by reset (gap C — overlays do NOT auto-clear).
      initialActiveOverlays: const ['hud'],
    );
  }
}
