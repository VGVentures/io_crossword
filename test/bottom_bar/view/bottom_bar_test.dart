// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/bottom_bar/bottom_bar.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockRandomWordSelectionBloc
    extends MockBloc<RandomWordSelectionEvent, RandomWordSelectionState>
    implements RandomWordSelectionBloc {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  group('$BottomBar', () {
    late WordSelectionBloc wordSelectionBloc;
    late RandomWordSelectionBloc randomWordSelectionBloc;
    late Widget widget;
    late AppLocalizations l10n;
    late AudioController audioController;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    setUp(() {
      audioController = _MockAudioController();
      wordSelectionBloc = _MockWordSelectionBloc();
      randomWordSelectionBloc = _MockRandomWordSelectionBloc();
      widget = MultiBlocProvider(
        providers: [
          BlocProvider<WordSelectionBloc>(
            create: (_) => wordSelectionBloc,
          ),
          BlocProvider<RandomWordSelectionBloc>(
            create: (_) => randomWordSelectionBloc,
          ),
        ],
        child: BottomBar(),
      );
    });

    testWidgets(
      'renders SizedBox.shrink when status is not empty',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(status: WordSelectionStatus.preSolving),
        );

        await tester.pumpApp(widget);

        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(BottomBarContent), findsNothing);
      },
    );

    testWidgets(
      'renders $BottomBarContent when status is empty',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          const WordSelectionState.initial(),
        );

        await tester.pumpApp(widget);

        expect(find.byType(BottomBarContent), findsOneWidget);
      },
    );

    testWidgets(
      'adds $RandomWordRequested event when find new word button is tapped',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          const WordSelectionState.initial(),
        );
        await tester.pumpApp(widget, audioController: audioController);

        await tester.tap(find.text(l10n.findNewWord));

        await tester.pumpAndSettle();

        verify(
          () => audioController.playSfx(Assets.music.startButton1),
        ).called(1);
        verify(
          () => randomWordSelectionBloc.add(RandomWordRequested()),
        ).called(1);
      },
    );

    group('$BottomBarContent', () {
      testWidgets(
        'displays endGame',
        (tester) async {
          await tester.pumpApp(BottomBarContent());

          expect(find.text(l10n.endGame), findsOneWidget);
        },
      );

      testWidgets(
        'displays EndGameCheck when endGame is tapped',
        (tester) async {
          await tester.pumpApp(
            BottomBarContent(),
            audioController: audioController,
          );

          await tester.tap(find.text(l10n.endGame));

          await tester.pumpAndSettle();

          verify(
            () => audioController.playSfx(Assets.music.startButton1),
          ).called(1);
          expect(find.byType(EndGameCheck), findsOneWidget);
        },
      );
    });
  });
}
