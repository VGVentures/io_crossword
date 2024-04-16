// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
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

  group('$WordPreSolvingView', () {
    group('renders', () {
      late WordSelection selectedWord;
      late WordSelectionBloc wordSelectionBloc;

      setUp(() {
        selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

        wordSelectionBloc = _MockWordFocusedBloc();
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        );
      });

      testWidgets(
        '$WordPreSolvingLargeView when layout is large',
        (tester) async {
          await tester.pumpApp(
            layout: IoLayoutData.large,
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordPreSolvingView(
                selectedWord: selectedWord,
              ),
            ),
          );

          expect(find.byType(WordPreSolvingLargeView), findsOneWidget);
          expect(find.byType(WordPreSolvingSmallView), findsNothing);
        },
      );

      testWidgets(
        '$WordPreSolvingSmallView when layout is small',
        (tester) async {
          await tester.pumpApp(
            layout: IoLayoutData.small,
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordPreSolvingView(
                selectedWord: selectedWord,
              ),
            ),
          );

          expect(find.byType(WordPreSolvingSmallView), findsOneWidget);
          expect(find.byType(WordPreSolvingLargeView), findsNothing);
        },
      );
    });
  });

  group('$WordPreSolvingLargeView', () {
    late WordSelection selectedWord;
    late Widget widget;
    late WordSelectionBloc wordSelectionBloc;

    group('with unsolved word', () {
      setUp(() {
        selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

        wordSelectionBloc = _MockWordFocusedBloc();
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        );

        widget = BlocProvider(
          create: (_) => wordSelectionBloc,
          child: WordPreSolvingLargeView(selectedWord),
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
        'tapping the solve button dispatches a $WordSolveRequested event',
        (tester) async {
          await tester.pumpApp(widget);

          await tester.tap(find.text(l10n.solveIt));

          verify(
            () => wordSelectionBloc.add(WordSolveRequested()),
          ).called(1);
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

        wordSelectionBloc = _MockWordFocusedBloc();
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        );

        widget = BlocProvider(
          create: (context) => wordSelectionBloc,
          child: WordPreSolvingLargeView(selectedWord),
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

  group('$WordPreSolvingSmallView', () {
    late WordSelection selectedWord;
    late Widget widget;
    late WordSelectionBloc wordSelectionBloc;

    group('with unsolved word', () {
      setUp(() {
        selectedWord = WordSelection(section: (0, 0), word: _FakeWord());
        wordSelectionBloc = _MockWordFocusedBloc();
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        );

        widget = BlocProvider(
          create: (context) => wordSelectionBloc,
          child: WordPreSolvingSmallView(selectedWord),
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
        'tapping the solve button dispatches a $WordSolveRequested event',
        (tester) async {
          await tester.pumpApp(widget);

          await tester.tap(find.text(l10n.solveIt));

          verify(
            () => wordSelectionBloc.add(WordSolveRequested()),
          ).called(1);
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

        wordSelectionBloc = _MockWordFocusedBloc();
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        );

        widget = BlocProvider(
          create: (context) => wordSelectionBloc,
          child: WordPreSolvingSmallView(selectedWord),
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
