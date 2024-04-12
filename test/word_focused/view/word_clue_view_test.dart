// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  int? get solvedTimestamp => null;
}

class _MockWordFocusedBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(Locale('en'));
  });

  group('WordClueDesktopView', () {
    late WordSelection selectedWord;
    late Widget widget;
    late WordSelectionBloc wordFocusedBloc;

    group('with unsolved word', () {
      setUp(() {
        selectedWord = WordSelection(section: (0, 0), word: _FakeWord());
        wordFocusedBloc = _MockWordFocusedBloc();

        widget = BlocProvider(
          create: (context) => wordFocusedBloc,
          child: WordClueDesktopView(selectedWord),
        );
      });

      testWidgets(
        'renders the selected word clue with solved button',
        (tester) async {
          await tester.pumpApp(widget);

          expect(find.text(selectedWord.word.clue), findsOneWidget);
          expect(find.text(l10n.solveIt), findsOneWidget);
        },
      );

      testWidgets(
        'tapping the solve button dispatches a WordFocusedSolveRequested event',
        (tester) async {
          await tester.pumpApp(widget);

          await tester.tap(find.text(l10n.solveIt));

          verify(() => wordFocusedBloc.add(const WordFocusedSolveRequested()))
              .called(1);
        },
      );
    });

    group('with solved word', () {
      setUp(() {
        selectedWord = WordSelection(
          section: (0, 0),
          word: _FakeWord(),
          solvedStatus: WordStatus.solved,
        );
        wordFocusedBloc = _MockWordFocusedBloc();

        widget = BlocProvider(
          create: (context) => wordFocusedBloc,
          child: WordClueDesktopView(selectedWord),
        );
      });

      testWidgets(
        'renders the selected word clue with solved button',
        (tester) async {
          await tester.pumpApp(widget);

          expect(find.text(selectedWord.word.clue), findsOneWidget);
          expect(find.text(l10n.solveIt), findsNothing);
        },
      );
    });
  });

  group('WordClueMobileView', () {
    late WordSelection selectedWord;
    late Widget widget;
    late WordSelectionBloc wordFocusedBloc;

    group('with unsolved word', () {
      setUp(() {
        selectedWord = WordSelection(section: (0, 0), word: _FakeWord());
        wordFocusedBloc = _MockWordFocusedBloc();

        widget = BlocProvider(
          create: (context) => wordFocusedBloc,
          child: WordClueMobileView(selectedWord),
        );
      });

      testWidgets(
        'renders the selected word clue',
        (tester) async {
          await tester.pumpApp(widget);

          expect(find.text(selectedWord.word.clue), findsOneWidget);
        },
      );

      testWidgets(
        'tapping the solve button dispatches a WordFocusedSolveRequested event',
        (tester) async {
          await tester.pumpApp(widget);

          await tester.tap(find.text(l10n.solveIt));

          verify(() => wordFocusedBloc.add(const WordFocusedSolveRequested()))
              .called(1);
        },
      );
    });

    group('with solved word', () {
      setUp(() {
        selectedWord = WordSelection(
          section: (0, 0),
          word: _FakeWord(),
          solvedStatus: WordStatus.solved,
        );
        wordFocusedBloc = _MockWordFocusedBloc();

        widget = BlocProvider(
          create: (context) => wordFocusedBloc,
          child: WordClueMobileView(selectedWord),
        );
      });

      testWidgets(
        'renders the selected word clue with solved button',
        (tester) async {
          await tester.pumpApp(widget);

          expect(find.text(selectedWord.word.clue), findsOneWidget);
          expect(find.text(l10n.solveIt), findsNothing);
        },
      );
    });
  });
}
