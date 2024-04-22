// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$LeaderboardButton', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets(
      'displays leaderboard',
      (tester) async {
        await tester.pumpApp(LeaderboardButton());

        expect(find.text(l10n.leaderboard), findsOneWidget);
      },
    );

    testWidgets(
      'displays LeaderboardPage when tapped on leaderboard',
      (tester) async {
        await tester.pumpApp(LeaderboardButton());

        await tester.tap(find.text(l10n.leaderboard));

        await tester.pumpAndSettle();

        expect(find.byType(LeaderboardPage), findsOneWidget);
      },
    );
  });
}
