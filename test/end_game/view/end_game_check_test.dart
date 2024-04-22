// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$EndGameCheck', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets(
      'displays EndGameCheck when openDialog is called',
      (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  EndGameCheck.openDialog(context);
                },
                child: Text('display dialog'),
              );
            },
          ),
        );

        await tester.tap(find.text('display dialog'));

        await tester.pumpAndSettle();

        expect(find.byType(EndGameCheck), findsOneWidget);
      },
    );

    testWidgets(
      'displays CloseButton',
      (tester) async {
        await tester.pumpApp(EndGameCheck());

        expect(find.byType(CloseButton), findsOneWidget);
      },
    );

    testWidgets(
      'displays sureToEndGame',
      (tester) async {
        await tester.pumpApp(EndGameCheck());

        expect(find.text(l10n.sureToEndGame), findsOneWidget);
      },
    );

    testWidgets(
      'displays endGame',
      (tester) async {
        await tester.pumpApp(EndGameCheck());

        expect(find.text(l10n.endGame), findsOneWidget);
      },
    );

    testWidgets(
      'displays EndGamePage when endGame tapped',
      (tester) async {
        await tester.pumpApp(EndGameCheck());

        await tester.tap(find.text(l10n.endGame));

        await tester.pumpAndSettle();

        expect(find.byType(EndGamePage), findsOneWidget);
      },
    );
  });
}
