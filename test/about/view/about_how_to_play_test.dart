// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/about/view/about_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AboutHowToPlayContent', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets(
      'renders HowToPlaySteps',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        expect(find.byType(HowToPlaySteps), findsOneWidget);
      },
    );

    testWidgets(
      'renders playNow text and play_circle icon',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        expect(find.text(l10n.playNow), findsOneWidget);
        expect(find.byIcon(Icons.play_circle), findsOneWidget);
      },
    );

    testWidgets(
      'calls pop when button is pressed',
      (tester) async {
        final mockNavigator = MockNavigator();

        when(mockNavigator.canPop).thenReturn(true);

        await tester.pumpApp(
          AboutHowToPlayContent(),
          navigator: mockNavigator,
        );

        await tester.tap(find.text(l10n.playNow));

        verify(mockNavigator.pop).called(1);
      },
    );
  });
}
