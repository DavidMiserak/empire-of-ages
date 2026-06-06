// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Empire of Ages: this widget originally hosted the Casual Games Toolkit's
// slider puzzle. T6 swapped it for a Flame GameWidget hosting AgeOfWarGame.
// The surrounding PlaySessionScreen scaffolding (settings button, back button,
// Toolkit Level/Score/Confetti machinery) is preserved for now and will be
// integrated with the real win/lose flow in T11.

import 'package:flame/game.dart' as flame;
import 'package:flutter/material.dart';

import '../game/age_of_war_game.dart';

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
    return flame.GameWidget(game: _game);
  }
}
