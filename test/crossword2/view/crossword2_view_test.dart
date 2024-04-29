import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as domain show Axis;
import 'package:game_domain/game_domain.dart' hide Axis;
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockWord extends Mock implements Word {}

void main() {
  group('$Crossword2View', () {
    late WordSelectionBloc wordSelectionBloc;
    late Word word;

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      when(() => wordSelectionBloc.state)
          .thenReturn(const WordSelectionState.initial());

      word = _MockWord();
      when(() => word.length).thenReturn(5);
      when(() => word.axis).thenReturn(domain.Axis.horizontal);
      when(() => word.position).thenReturn(const Point(0, 0));
      when(() => word.id).thenReturn('id');
      when(() => word.answer).thenReturn('word');
      when(() => word.isSolved).thenReturn(false);
      when(() => word.solvedTimestamp).thenReturn(null);
    });

    testWidgets('requests chunk', (tester) async {
      final crosswordBloc = _MockCrosswordBloc();
      when(() => crosswordBloc.state).thenReturn(const CrosswordState());

      await tester.pumpApp(
        crosswordBloc: crosswordBloc,
        BlocProvider<WordSelectionBloc>(
          create: (_) => wordSelectionBloc,
          child: const Crossword2View(),
        ),
      );

      verify(() => crosswordBloc.add(const BoardSectionRequested((0, 0))))
          .called(1);
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(
        BlocProvider<WordSelectionBloc>(
          create: (_) => wordSelectionBloc,
          child: const Crossword2View(),
        ),
      );

      expect(find.byType(Crossword2View), findsOneWidget);
    });

    group('$CrosswordBackdrop', () {
      group('shown', () {
        testWidgets('when an unsolved word is selected', (tester) async {
          when(() => word.solvedTimestamp).thenReturn(null);
          when(() => word.isSolved).thenReturn(false);

          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: (0, 0),
                word: word,
              ),
            ),
          );

          await tester.pumpApp(
            layout: IoLayoutData.large,
            DefaultWordInputController(
              child: BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            ),
          );

          expect(find.byType(CrosswordBackdrop), findsOneWidget);
        });

        testWidgets('when a solved word is selected', (tester) async {
          when(() => word.solvedTimestamp).thenReturn(1);
          when(() => word.isSolved).thenReturn(true);

          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: (0, 0),
                word: word,
              ),
            ),
          );

          await tester.pumpApp(
            layout: IoLayoutData.large,
            BlocProvider<WordSelectionBloc>(
              create: (_) => wordSelectionBloc,
              child: const Crossword2View(),
            ),
          );

          expect(find.byType(CrosswordBackdrop), findsOneWidget);
        });
      });

      group('not shown', () {
        testWidgets(
          'when a solved word is selected with a small layout',
          (tester) async {
            when(() => word.solvedTimestamp).thenReturn(1);
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.small,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(CrosswordBackdrop), findsNothing);
          },
        );

        testWidgets(
          'when an unsolved word is selected with a small layout',
          (tester) async {
            when(() => word.solvedTimestamp).thenReturn(null);
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.small,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(CrosswordBackdrop), findsNothing);
          },
        );

        testWidgets(
          'when no word is selected with a large layout',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              const WordSelectionState(
                status: WordSelectionStatus.empty,
                // ignore: avoid_redundant_argument_values
                word: null,
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(CrosswordBackdrop), findsNothing);
          },
        );
      });
    });

    group('$IoWordInput', () {
      group('shown', () {
        testWidgets(
          'horizontally when an horizontal word is to be solved',
          (tester) async {
            when(() => word.isSolved).thenReturn(false);
            when(() => word.axis).thenReturn(domain.Axis.horizontal);

            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              DefaultWordInputController(
                child: BlocProvider<WordSelectionBloc>(
                  create: (_) => wordSelectionBloc,
                  child: const Crossword2View(),
                ),
              ),
            );

            final wordInputFinder = find.byType(IoWordInput);
            expect(wordInputFinder, findsOneWidget);

            final wordInput = tester.widget<IoWordInput>(wordInputFinder);
            expect(wordInput.direction, equals(Axis.horizontal));
          },
        );

        testWidgets(
          'vertically when a vertical word is to be solved',
          (tester) async {
            when(() => word.isSolved).thenReturn(false);
            when(() => word.axis).thenReturn(domain.Axis.vertical);

            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              DefaultWordInputController(
                child: BlocProvider<WordSelectionBloc>(
                  create: (_) => wordSelectionBloc,
                  child: const Crossword2View(),
                ),
              ),
            );

            final wordInputFinder = find.byType(IoWordInput);
            expect(wordInputFinder, findsOneWidget);

            final wordInput = tester.widget<IoWordInput>(wordInputFinder);
            expect(wordInput.direction, equals(Axis.vertical));
          },
        );
      });

      group('not shown', () {
        testWidgets(
          'when word is not solved with a small layout',
          (tester) async {
            when(() => word.isSolved).thenReturn(false);

            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.small,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );

        testWidgets(
          'when word is solved',
          (tester) async {
            when(() => word.isSolved).thenReturn(true);

            when(() => word.solvedTimestamp).thenReturn(1);
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );

        testWidgets(
          'when there is no selected word',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              const WordSelectionState(
                status: WordSelectionStatus.empty,
                // ignore: avoid_redundant_argument_values
                word: null,
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );
      });
    });

    group('$IoWord', () {
      group('shown', () {
        testWidgets(
          'with answer when word is solved',
          (tester) async {
            when(() => word.isSolved).thenReturn(true);

            when(() => word.solvedTimestamp).thenReturn(1);
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            );

            final ioWordFinder = find.byType(IoWord);
            expect(ioWordFinder, findsOneWidget);

            final ioWord = tester.widget<IoWord>(ioWordFinder);
            expect(ioWord.data, equals(word.answer));
          },
        );

        testWidgets(
          'with mascot styling when word is solved',
          (tester) async {
            when(() => word.isSolved).thenReturn(true);
            when(() => word.mascot).thenReturn(Mascots.dash);

            when(() => word.solvedTimestamp).thenReturn(1);
            when(() => wordSelectionBloc.state).thenReturn(
              WordSelectionState(
                status: WordSelectionStatus.preSolving,
                word: SelectedWord(
                  section: (0, 0),
                  word: word,
                ),
              ),
            );

            final themeData = IoCrosswordTheme().themeData;

            await tester.pumpApp(
              layout: IoLayoutData.large,
              Theme(
                data: themeData,
                child: BlocProvider<WordSelectionBloc>(
                  create: (_) => wordSelectionBloc,
                  child: const Crossword2View(),
                ),
              ),
            );

            final ioWordFinder = find.byType(IoWord);
            expect(ioWordFinder, findsOneWidget);

            final ioWord = tester.widget<IoWord>(ioWordFinder);

            final actualStyle = ioWord.style;
            final expectedStyle = IoWordStyle(
              margin: themeData.io.wordInput.secondary.padding,
              boxSize: themeData.io.wordInput.secondary.filled.size,
              borderRadius: BorderRadius.zero,
              backgroundColor:
                  themeData.io.crosswordLetterTheme.dash.backgroundColor,
              textStyle: themeData.io.crosswordLetterTheme.dash.textStyle,
            );

            expect(actualStyle, equals(expectedStyle));
          },
        );
      });

      testWidgets(
        'not shown when word is not solved',
        (tester) async {
          when(() => word.isSolved).thenReturn(false);

          when(() => word.solvedTimestamp).thenReturn(1);
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: (0, 0),
                word: word,
              ),
            ),
          );

          await tester.pumpApp(
            layout: IoLayoutData.large,
            DefaultWordInputController(
              child: BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const Crossword2View(),
              ),
            ),
          );

          expect(find.byType(IoWord), findsNothing);
        },
      );
    });
  });
}
