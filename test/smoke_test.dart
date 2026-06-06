// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Empire of Ages: this smoke test was inherited from the Casual Games Toolkit
// template (T1) and originally verified the toolkit's slider-puzzle level.
// T6 replaced the level with a FlameGame, so the test now verifies the
// Toolkit's surrounding chrome (menus, settings, level selection, navigation)
// boots and that selecting Level #1 mounts the play session without throwing.

import 'package:empire_of_ages/main.dart';
import 'package:empire_of_ages/play_session/game_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('toolkit chrome + game widget mounts', (tester) async {
    await tester.pumpWidget(MyApp());

    // Main menu shows PLAY and SETTINGS buttons (uppercase post-redesign).
    expect(find.text('PLAY'), findsOneWidget);
    expect(find.text('SETTINGS'), findsOneWidget);

    // Settings is reachable.
    await tester.tap(find.text('SETTINGS'));
    await tester.pumpAndSettle();
    expect(find.text('Music'), findsOneWidget);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Play -> level selection.
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your battlefield'), findsOneWidget);

    // Selecting a level lands on the play session. We pump a few frames to
    // let go_router's route transition complete, but stop short of
    // pumpAndSettle because FlameGame's render loop never quiesces.
    await tester.tap(find.text('Battle 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Use byWidgetPredicate rather than byType because flame's GameWidget is
    // a parameterized type (GameWidget<Game>) and Type identity matching
    // through prefixed imports is unreliable for generics.
    expect(
      find.byWidgetPredicate((w) => w is GameWidget),
      findsOneWidget,
      reason: 'empire_of_ages GameWidget should be mounted on play session',
    );
  });
}
