// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWord extends Mock implements Word {}

class _MockWordFocusedBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  late SelectedWord selectedWord;

  setUp(() async {
    final word = _MockWord();
    when(() => word.clue).thenReturn('clue');
    when(() => word.length).thenReturn(5);
    when(() => word.id).thenReturn('1');
    when(() => word.solvedTimestamp).thenReturn(null);
    when(() => word.axis).thenReturn(Axis.horizontal);

    selectedWord = SelectedWord(section: (0, 0), word: word);
  });

  group('$WordPreSolvingView', () {
    group('renders', () {
      late WordSelectionBloc wordSelectionBloc;

      setUp(() {
        wordSelectionBloc = _MockWordFocusedBloc();
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            word: selectedWord,
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
              child: WordPreSolvingView(),
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
              child: WordPreSolvingView(),
            ),
          );

          expect(find.byType(WordPreSolvingSmallView), findsOneWidget);
          expect(find.byType(WordPreSolvingLargeView), findsNothing);
        },
      );
    });
  });

  group('$WordPreSolvingLargeView', () {
    late Widget widget;
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordFocusedBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.preSolving,
          word: selectedWord,
        ),
      );

      widget = BlocProvider(
        create: (_) => wordSelectionBloc,
        child: WordPreSolvingLargeView(),
      );
    });

    testWidgets(
      'tapping the solve button dispatches a $WordSolveRequested event',
      (tester) async {
        late AppLocalizations l10n;
        await tester.pumpApp(
          Builder(
            builder: (context) {
              l10n = context.l10n;
              return widget;
            },
          ),
        );

        await tester.tap(find.text(l10n.solveIt));

        verify(
          () => wordSelectionBloc.add(WordSolveRequested()),
        ).called(1);
      },
    );

    group('renders', () {
      testWidgets(
        'the selected word clue with solved button',
        (tester) async {
          await tester.pumpApp(widget);

          expect(find.text(selectedWord.word.clue), findsOneWidget);
        },
      );

      testWidgets(
        'the solve button when the word is not solved',
        (tester) async {
          late AppLocalizations l10n;
          await tester.pumpApp(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return widget;
              },
            ),
          );

          expect(find.text(l10n.solveIt), findsOneWidget);
        },
      );

      testWidgets(
        'no solve button when the word is solved',
        (tester) async {
          when(() => selectedWord.word.solvedTimestamp).thenReturn(1);

          late AppLocalizations l10n;
          await tester.pumpApp(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return widget;
              },
            ),
          );

          expect(find.text(l10n.solveIt), findsNothing);
        },
      );
    });
  });

  group('$WordPreSolvingSmallView', () {
    late Widget widget;
    late WordSelectionBloc wordSelectionBloc;

    setUp(() {
      wordSelectionBloc = _MockWordFocusedBloc();
      when(() => wordSelectionBloc.state).thenReturn(
        WordSelectionState(
          status: WordSelectionStatus.preSolving,
          word: selectedWord,
        ),
      );

      widget = BlocProvider(
        create: (_) => wordSelectionBloc,
        child: WordPreSolvingSmallView(),
      );
    });

    group('renders', () {
      testWidgets(
        'the selected word clue with solved button',
        (tester) async {
          await tester.pumpApp(widget);

          expect(find.text(selectedWord.word.clue), findsOneWidget);
        },
      );

      testWidgets(
        'the solve button when the word is not solved',
        (tester) async {
          late AppLocalizations l10n;
          await tester.pumpApp(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return widget;
              },
            ),
          );

          expect(find.text(l10n.solveIt), findsOneWidget);
        },
      );

      testWidgets(
        'no solve button when the word is solved',
        (tester) async {
          when(() => selectedWord.word.solvedTimestamp).thenReturn(1);

          late AppLocalizations l10n;
          await tester.pumpApp(
            Builder(
              builder: (context) {
                l10n = context.l10n;
                return widget;
              },
            ),
          );

          expect(find.text(l10n.solveIt), findsNothing);
        },
      );
    });
  });
}
