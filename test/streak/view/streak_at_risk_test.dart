// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/streak/streak.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$StreakAtRiskView', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets(
      'renders $IoPhysicalModel',
      (tester) async {
        await tester.pumpApp(StreakAtRiskView());

        expect(find.byType(IoPhysicalModel), findsOneWidget);
      },
    );

    testWidgets(
      'renders $CloseButton',
      (tester) async {
        await tester.pumpApp(StreakAtRiskView());

        expect(find.byType(CloseButton), findsOneWidget);
      },
    );

    testWidgets(
      'displays streakAtRiskMessage',
      (tester) async {
        await tester.pumpApp(StreakAtRiskView());

        expect(find.text(l10n.streakAtRiskMessage), findsOneWidget);
      },
    );

    testWidgets(
      'displays continuationConfirmation',
      (tester) async {
        await tester.pumpApp(StreakAtRiskView());

        expect(find.text(l10n.streakAtRiskMessage), findsOneWidget);
      },
    );

    testWidgets(
      'renders $LeaveButton',
      (tester) async {
        await tester.pumpApp(StreakAtRiskView());

        expect(find.byType(LeaveButton), findsOneWidget);
      },
    );

    testWidgets(
      'renders $SolveItButton',
      (tester) async {
        await tester.pumpApp(StreakAtRiskView());

        expect(find.byType(SolveItButton), findsOneWidget);
      },
    );

    testWidgets(
      'calls pop when $SolveItButton is tapped',
      (tester) async {
        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);

        await tester.pumpApp(
          StreakAtRiskView(),
          navigator: mockNavigator,
        );

        await tester.tap(find.byType(SolveItButton));

        await tester.pumpAndSettle();

        verify(mockNavigator.pop).called(1);
      },
    );
  });
}
