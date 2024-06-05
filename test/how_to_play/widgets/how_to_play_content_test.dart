// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockHowToPlayCubit extends MockCubit<HowToPlayState>
    implements HowToPlayCubit {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  group('HowToPlayContent', () {
    late AudioController audioController;
    late AppLocalizations l10n;
    late HowToPlayCubit howToPlayCubit;
    late Widget widget;

    setUp(() {
      audioController = _MockAudioController();
      howToPlayCubit = _MockHowToPlayCubit();

      widget = BlocProvider.value(
        value: howToPlayCubit,
        child: HowToPlayContent(
          mascot: Mascot.dash,
          onDonePressed: () {},
        ),
      );

      when(() => howToPlayCubit.state).thenReturn(HowToPlayState());
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
          Stream.value(HowToPlayState(index: 1)),
          initialState: HowToPlayState(),
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
          Stream.fromIterable([
            HowToPlayState(index: 1),
            HowToPlayState(index: 2),
          ]),
          initialState: HowToPlayState(),
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
          Stream.fromIterable([
            HowToPlayState(index: 1),
            HowToPlayState(index: 2),
            HowToPlayState(index: 3),
          ]),
          initialState: HowToPlayState(),
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
          Stream.fromIterable([HowToPlayState()]),
          initialState: HowToPlayState(index: 1),
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
      'plays ${Assets.music.startButton1} when back button is pressed',
      (tester) async {
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([
            HowToPlayState(index: 1),
            HowToPlayState(index: 2),
          ]),
          initialState: HowToPlayState(index: 2),
        );
        await tester.pumpApp(widget, audioController: audioController);

        await tester.tap(find.text(l10n.backButtonLabel));
        await tester.pumpAndSettle();

        verify(
          () => audioController.playSfx(Assets.music.arrowsSound),
        ).called(1);
      },
    );

    testWidgets(
      'plays ${Assets.music.startButton1} when next button is pressed',
      (tester) async {
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([
            HowToPlayState(index: 1),
            HowToPlayState(index: 2),
          ]),
          initialState: HowToPlayState(index: 1),
        );

        await tester.pumpApp(widget, audioController: audioController);

        await tester.tap(find.text(l10n.nextButtonLabel));
        await tester.pumpAndSettle();

        verify(
          () => audioController.playSfx(Assets.music.arrowsSound),
        ).called(1);
      },
    );

    testWidgets(
      'renders first tab view aboutHowToPlayFirstInstructions when next is '
      'pressed twice and previous is pressed more than passing '
      'through initial value',
      (tester) async {
        whenListen(
          howToPlayCubit,
          Stream.fromIterable([
            HowToPlayState(index: 1),
            HowToPlayState(index: 2),
            HowToPlayState(index: 1),
            HowToPlayState(),
          ]),
          initialState: HowToPlayState(),
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
          Stream.fromIterable([HowToPlayState(index: 4)]),
          initialState: HowToPlayState(index: 3),
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
        when(() => howToPlayCubit.state).thenReturn(HowToPlayState());

        for (final mascot in Mascot.values) {
          await tester.pumpApp(
            BlocProvider.value(
              value: howToPlayCubit,
              child: HowToPlayContent(
                mascot: mascot,
                onDonePressed: () {},
              ),
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
        when(() => howToPlayCubit.state).thenReturn(HowToPlayState(index: 1));

        for (final mascot in Mascot.values) {
          await tester.pumpApp(
            BlocProvider.value(
              value: howToPlayCubit,
              child: HowToPlayContent(
                mascot: mascot,
                onDonePressed: () {},
              ),
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
        when(() => howToPlayCubit.state).thenReturn(HowToPlayState(index: 2));

        for (final mascot in Mascot.values) {
          await tester.pumpApp(
            BlocProvider.value(
              value: howToPlayCubit,
              child: HowToPlayContent(
                mascot: mascot,
                onDonePressed: () {},
              ),
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
