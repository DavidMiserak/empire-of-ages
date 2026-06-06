// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A palette of colors to be used in the game.
///
/// The reason we're not going with something like Material Design's
/// `Theme` is simply that this is simpler to work with and yet gives
/// us everything we need for a game.
///
/// Games generally have more radical color palettes than apps. For example,
/// every level of a game can have radically different colors.
/// At the same time, games rarely support dark mode.
///
/// Colors taken from this fun palette:
/// https://lospec.com/palette-list/crayola84
///
/// Colors here are implemented as getters so that hot reloading works.
/// In practice, we could just as easily implement the colors
/// as `static const`. But this way the palette is more malleable:
/// we could allow players to customize colors, for example,
/// or even get the colors from the network.
class Palette {
  // Empire of Ages — dark battle palette. Cream/mint/lavender pastels
  // from the Toolkit's `crayola84` palette read as 'casual notebook
  // puzzle' and clashed every time a screen transitioned into the
  // dark-navy in-game world. Each menu now matches the battlefield.
  Color get pen => const Color(0xffFFCA28); // gold accent (matches HUD coin)
  Color get darkPen => const Color(0xffC79100); // darker gold for pressed states
  Color get redPen => const Color(0xffEF5350); // alert / defeat red
  Color get inkFullOpacity => const Color(0xffE6ECF5); // body text on dark
  Color get ink => const Color(0xeeE6ECF5);
  Color get backgroundMain => const Color(0xff1A2638); // sky navy
  Color get backgroundLevelSelection => const Color(0xff141E2D);
  Color get backgroundPlaySession => const Color(0xff0F1722); // ground/earth
  Color get background4 => const Color(0xff1A2638);
  Color get backgroundSettings => const Color(0xff141E2D);
  Color get trueWhite => const Color(0xffffffff);
}
