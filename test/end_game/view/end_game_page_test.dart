// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$EndGamePage', () {
    testWidgets('displays EngGameLargeView with ${IoLayoutData.large}',
        (tester) async {
      await tester.pumpApp(
        EndGamePage(),
        layout: IoLayoutData.large,
      );

      expect(find.byType(EngGameLargeView), findsOneWidget);
    });

    testWidgets('displays EndGameSmallView with ${IoLayoutData.small}',
        (tester) async {
      await tester.pumpApp(
        EndGamePage(),
        layout: IoLayoutData.small,
      );

      expect(find.byType(EndGameSmallView), findsOneWidget);
    });
  });

  group('$EngGameLargeView', () {
    testWidgets('displays LeaderboardButton', (tester) async {
      await tester.pumpApp(EngGameLargeView());

      expect(find.byType(LeaderboardButton), findsOneWidget);
    });

    testWidgets('displays EndGameContent', (tester) async {
      await tester.pumpApp(EngGameLargeView());

      expect(find.byType(EndGameContent), findsOneWidget);
    });

    testWidgets('displays ActionButtonsEndGame', (tester) async {
      await tester.pumpApp(EngGameLargeView());

      expect(find.byType(ActionButtonsEndGame), findsOneWidget);
    });
  });

  group('$EndGameSmallView', () {
    testWidgets('displays LeaderboardButton', (tester) async {
      await tester.pumpApp(EndGameSmallView());

      expect(find.byType(LeaderboardButton), findsOneWidget);
    });

    testWidgets('displays EndGameContent', (tester) async {
      await tester.pumpApp(EndGameSmallView());

      expect(find.byType(EndGameContent), findsOneWidget);
    });

    testWidgets('displays Image', (tester) async {
      await tester.pumpApp(EndGameSmallView());

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays ActionButtonsEndGame', (tester) async {
      await tester.pumpApp(EndGameSmallView());

      expect(find.byType(ActionButtonsEndGame), findsOneWidget);
    });
  });
}
