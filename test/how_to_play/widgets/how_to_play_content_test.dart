// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockHowToPlayCubit extends MockCubit<int> implements HowToPlayCubit {}

void main() {
  group('HowToPlayContent', () {
    late AppLocalizations l10n;
    late HowToPlayCubit howToPlayCubit;
    late Widget widget;

    setUp(() {
      howToPlayCubit = _MockHowToPlayCubit();

      widget = BlocProvider.value(
        value: howToPlayCubit,
        child: HowToPlayContent(mascot: Mascots.dash),
      );

      when(() => howToPlayCubit.state).thenReturn(0);
    });

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets(
      'renders HowToPlayStep',
      (tester) async {
        await tester.pumpApp(widget);

        expect(find.byType(HowToPlayStep), findsOneWidget);
      },
    );

    testWidgets(
      'renders initial aboutHowToPlayFirstInstructions',
      (tester) async {
        await tester.pumpApp(widget);

        expect(find.text(l10n.aboutHowToPlayFirstInstructions), findsOneWidget);
      },
    );

    testWidgets(
      'renders second tab view aboutHowToPlaySecondInstructions '
      'when next icon is pressed',
      (tester) async {
        whenListen(
          howToPlayCubit,
          Stream.value(1),
          initialState: 0,
        );

        await tester.pumpApp(widget);

        await tester.tap(find.text(l10n.nextButtonLabel));

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
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([1, 2]),
          initialState: 0,
        );

        await tester.pumpApp(widget);

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.nextButtonLabel));
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
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([1, 2, 3]),
          initialState: 0,
        );

        await tester.pumpApp(widget);

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayFourthInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'back button goes back to previous tab view',
      (tester) async {
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([0]),
          initialState: 1,
        );

        await tester.pumpApp(widget);

        await tester.tap(find.text(l10n.backButtonLabel));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayFirstInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders first tab view aboutHowToPlayFirstInstructions when next is '
      'pressed twice and previous is pressed more than passing '
      'through initial value',
      (tester) async {
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([1, 2, 1, 0]),
          initialState: 0,
        );

        await tester.pumpApp(widget);

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.backButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.backButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.backButtonLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(l10n.backButtonLabel));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.aboutHowToPlayFirstInstructions),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders done button when on last step',
      (tester) async {
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([4]),
          initialState: 3,
        );

        await tester.pumpApp(widget);

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        expect(
          find.text(l10n.doneButtonLabel),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders correct step 1 assets',
      (tester) async {
        when(() => howToPlayCubit.state).thenReturn(0);

        for (final mascot in Mascots.values) {
          await tester.pumpApp(
            BlocProvider.value(
              value: howToPlayCubit,
              child: HowToPlayContent(mascot: mascot),
            ),
          );

          expect(
            find.image(mascot.teamMascot.howToPlayFindWord.provider()),
            findsOneWidget,
          );
        }
      },
    );

    testWidgets(
      'renders correct step 2 assets',
      (tester) async {
        when(() => howToPlayCubit.state).thenReturn(1);

        for (final mascot in Mascots.values) {
          await tester.pumpApp(
            BlocProvider.value(
              value: howToPlayCubit,
              child: HowToPlayContent(mascot: mascot),
            ),
          );

          expect(
            find.image(mascot.teamMascot.howToPlayAnswer.provider()),
            findsOneWidget,
          );
        }
      },
    );

    testWidgets(
      'renders correct step 3 assets',
      (tester) async {
        when(() => howToPlayCubit.state).thenReturn(2);

        for (final mascot in Mascots.values) {
          await tester.pumpApp(
            BlocProvider.value(
              value: howToPlayCubit,
              child: HowToPlayContent(mascot: mascot),
            ),
          );

          expect(
            find.image(mascot.teamMascot.howToPlayStreak.provider()),
            findsOneWidget,
          );
        }
      },
    );
  });
}