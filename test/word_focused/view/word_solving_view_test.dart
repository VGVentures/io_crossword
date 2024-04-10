// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockWordFocusedBloc extends MockBloc<WordFocusedEvent, WordFocusedState>
    implements WordFocusedBloc {}

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  Axis get axis => Axis.horizontal;

  @override
  int? get solvedTimestamp => null;

  @override
  String get answer => 'answer';
}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  group('WordSolvingDesktopView', () {
    late WordFocusedBloc wordFocusedBloc;
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      wordFocusedBloc = _MockWordFocusedBloc();
      crosswordBloc = _MockCrosswordBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: wordFocusedBloc),
          BlocProvider.value(value: crosswordBloc),
        ],
        child: WordSolvingDesktopView(selectedWord),
      );

      when(() => crosswordBloc.state).thenReturn(
        CrosswordLoaded(
          sectionSize: 20,
          selectedWord: selectedWord,
        ),
      );
      when(() => wordFocusedBloc.state).thenReturn(WordFocusedState());
    });

    testWidgets(
      'renders the clue text',
      (tester) async {
        await tester.pumpApp(widget);

        expect(find.text(selectedWord.word.clue), findsOneWidget);
      },
    );

    testWidgets(
      'tapping the close button sends WordUnselected event',
      (tester) async {
        await tester.pumpApp(widget);

        final closeButton = find.byIcon(Icons.cancel);
        await tester.tap(closeButton);

        verify(() => crosswordBloc.add(const WordUnselected())).called(1);
      },
    );

    testWidgets(
      'tapping the submit button sends AnswerSubmitted event',
      (tester) async {
        await tester.pumpApp(widget);

        final submitButton = find.text(l10n.submit);
        await tester.tap(submitButton);

        verify(() => crosswordBloc.add(const AnswerSubmitted())).called(1);
      },
    );

    testWidgets(
      'tapping the hint button sends SolvingFocusSwitched event',
      (tester) async {
        await tester.pumpApp(widget);

        final hintButton = find.text(l10n.hint);
        await tester.tap(hintButton);

        verify(
          () => wordFocusedBloc.add(const SolvingFocusSwitched()),
        ).called(1);
      },
    );

    testWidgets(
      'tapping send button when focus is hint sends SolvingFocusSwitched event',
      (tester) async {
        when(() => wordFocusedBloc.state).thenReturn(
          WordFocusedState(focus: WordSolvingFocus.hint),
        );
        await tester.pumpApp(widget);

        final sendButton = find.byIcon(Icons.send);
        await tester.tap(sendButton);

        verify(
          () => wordFocusedBloc.add(const SolvingFocusSwitched()),
        ).called(1);
      },
    );

    testWidgets(
      'adds WordFocusedSuccessRequested event when state changes with solved '
      'selected word',
      (tester) async {
        whenListen(
          crosswordBloc,
          Stream.value(
            CrosswordLoaded(
              sectionSize: 20,
              selectedWord: selectedWord.copyWith(
                solvedStatus: WordStatus.solved,
              ),
            ),
          ),
        );
        await tester.pumpApp(widget);

        verify(() => wordFocusedBloc.add(const WordFocusedSuccessRequested()))
            .called(1);
      },
    );
  });

  group('WordFocusedMobileView', () {
    late WordFocusedBloc wordFocusedBloc;
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      wordFocusedBloc = _MockWordFocusedBloc();
      crosswordBloc = _MockCrosswordBloc();

      widget = Theme(
        data: IoCrosswordTheme().themeData,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: wordFocusedBloc),
            BlocProvider.value(value: crosswordBloc),
          ],
          child: WordFocusedMobileView(selectedWord),
        ),
      );

      when(() => wordFocusedBloc.state).thenReturn(
        WordFocusedState(status: WordFocusedStatus.solving),
      );
      when(() => crosswordBloc.state).thenReturn(
        CrosswordLoaded(
          sectionSize: 20,
          selectedWord: selectedWord,
        ),
      );
    });

    testWidgets(
      'add AnswerUpdated event when user enters all the letters',
      (tester) async {
        await tester.pumpApp(widget);

        final input = tester.widget<IoWordInput>(find.byType(IoWordInput));
        input.onWord!('answer');

        verify(
          () => crosswordBloc.add(const AnswerUpdated('answer')),
        ).called(1);
      },
    );

    testWidgets(
      'tap the submit button sends AnswerSubmitted event',
      (tester) async {
        await tester.pumpApp(widget);

        final submitButton = find.text(l10n.submit);
        await tester.tap(submitButton);
        verify(() => crosswordBloc.add(const AnswerSubmitted())).called(1);
      },
    );

    testWidgets(
      'adds WordFocusedSuccessRequested event when state changes with solved '
      'selected word',
      (tester) async {
        whenListen(
          crosswordBloc,
          Stream.value(
            CrosswordLoaded(
              sectionSize: 20,
              selectedWord: selectedWord.copyWith(
                solvedStatus: WordStatus.solved,
              ),
            ),
          ),
        );
        await tester.pumpApp(widget);

        verify(() => wordFocusedBloc.add(const WordFocusedSuccessRequested()))
            .called(1);
      },
    );
  });
}
