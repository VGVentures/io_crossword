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

        expect(find.byType(HowToPlayStep), findsOneWidget);
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
      'renders initial aboutHowToPlayFirstInstructions',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        expect(find.text(l10n.aboutHowToPlayFirstInstructions), findsOneWidget);
      },
    );

    testWidgets(
      'renders second tab view aboutHowToPlaySecondInstructions '
      'when next icon is pressed',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));

        await tester.pumpAndSettle();

        expect(find.text(l10n.aboutHowToPlayFirstInstructions), findsNothing);

        expect(
          find.text(l10n.aboutHowToPlaySecondInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders third tab view aboutHowToPlayThirdInstructions '
      'when next icon is pressed twice',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayThirdInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders fourth tab view aboutHowToPlayFourthInstructions '
      'when next icon is pressed three times',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayFourthInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders fifth tab view aboutHowToPlayFifthInstructions '
      'when next icon is pressed four times',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayFifthInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders fifth tab view aboutHowToPlayFifthInstructions '
      'when next is pressed more than the actual tab pages',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayFifthInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders first tab view aboutHowToPlayFirstInstructions when next is '
      'pressed twice and previous is pressed more than passing '
      'through initial value',
      (tester) async {
        await tester.pumpApp(AboutHowToPlayContent());

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_left));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_left));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_left));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.keyboard_arrow_left));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayFirstInstructions),
          findsOneWidget,
        );
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
