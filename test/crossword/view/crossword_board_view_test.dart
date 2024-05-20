import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as domain show Axis;
import 'package:game_domain/game_domain.dart' hide Axis;
import 'package:io_crossword/crossword/crossword.dart';
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
  group('$CrosswordBoardView', () {
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
      when(() => word.solvedCharacters).thenReturn({});
    });

    testWidgets('pumps successfully', (tester) async {
      final crosswordBloc = _MockCrosswordBloc();
      when(() => crosswordBloc.state).thenReturn(
        const CrosswordState(sectionSize: 20),
      );

      await tester.pumpApp(
        BlocProvider<WordSelectionBloc>(
          create: (_) => wordSelectionBloc,
          child: const CrosswordBoardView(),
        ),
        crosswordBloc: crosswordBloc,
      );

      expect(find.byType(CrosswordBoardView), findsOneWidget);
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
                child: const CrosswordBoardView(),
              ),
            ),
          );

          expect(find.byType(CrosswordBackdrop), findsOneWidget);
        });

        testWidgets('when a solved word is selected', (tester) async {
          when(() => word.solvedTimestamp).thenReturn(1);
          when(() => word.isSolved).thenReturn(true);
          when(() => word.mascot).thenReturn(Mascots.dash);

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
              child: const CrosswordBoardView(),
            ),
          );

          expect(find.byType(CrosswordBackdrop), findsOneWidget);
        });

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
                child: const CrosswordBoardView(),
              ),
            );

            expect(find.byType(CrosswordBackdrop), findsOneWidget);
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
                child: const CrosswordBoardView(),
              ),
            );

            expect(find.byType(CrosswordBackdrop), findsOneWidget);
          },
        );
      });

      group('not shown', () {
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
                child: const CrosswordBoardView(),
              ),
            );

            expect(find.byType(CrosswordBackdrop), findsNothing);
          },
        );

        testWidgets(
          'when no word is selected with a small layout',
          (tester) async {
            when(() => wordSelectionBloc.state).thenReturn(
              const WordSelectionState(
                status: WordSelectionStatus.empty,
                // ignore: avoid_redundant_argument_values
                word: null,
              ),
            );

            await tester.pumpApp(
              layout: IoLayoutData.small,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const CrosswordBoardView(),
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
                status: WordSelectionStatus.solving,
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
                  child: const CrosswordBoardView(),
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
                status: WordSelectionStatus.solving,
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
                  child: const CrosswordBoardView(),
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
                child: const CrosswordBoardView(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );

        testWidgets(
          'when word is solved',
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

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const CrosswordBoardView(),
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
                child: const CrosswordBoardView(),
              ),
            );

            expect(find.byType(IoWordInput), findsNothing);
          },
        );
      });
    });

    group('$IoWord', () {
      group('shown', () {
        setUp(() {
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: (0, 0),
                word: word,
              ),
            ),
          );
        });

        testWidgets(
          'with answer when word is solved',
          (tester) async {
            when(() => word.isSolved).thenReturn(true);
            when(() => word.mascot).thenReturn(Mascots.dash);
            when(() => word.solvedTimestamp).thenReturn(1);

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const CrosswordBoardView(),
              ),
            );

            final ioWordFinder = find.byType(IoWord);
            expect(ioWordFinder, findsOneWidget);

            final ioWord = tester.widget<IoWord>(ioWordFinder);
            expect(ioWord.data, equals(word.answer));
          },
        );

        testWidgets(
          'horizontally when word is horizontal',
          (tester) async {
            when(() => word.isSolved).thenReturn(true);
            when(() => word.mascot).thenReturn(Mascots.dash);
            when(() => word.solvedTimestamp).thenReturn(1);
            when(() => word.axis).thenReturn(domain.Axis.horizontal);

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const CrosswordBoardView(),
              ),
            );

            final ioWordFinder = find.byType(IoWord);
            expect(ioWordFinder, findsOneWidget);

            final ioWord = tester.widget<IoWord>(ioWordFinder);
            expect(ioWord.direction, equals(Axis.horizontal));
          },
        );

        testWidgets(
          'vertically when word is vertical',
          (tester) async {
            when(() => word.isSolved).thenReturn(true);
            when(() => word.mascot).thenReturn(Mascots.dash);
            when(() => word.solvedTimestamp).thenReturn(1);
            when(() => word.axis).thenReturn(domain.Axis.vertical);

            await tester.pumpApp(
              layout: IoLayoutData.large,
              BlocProvider<WordSelectionBloc>(
                create: (_) => wordSelectionBloc,
                child: const CrosswordBoardView(),
              ),
            );

            final ioWordFinder = find.byType(IoWord);
            expect(ioWordFinder, findsOneWidget);

            final ioWord = tester.widget<IoWord>(ioWordFinder);
            expect(ioWord.direction, equals(Axis.vertical));
          },
        );

        group('with mascot styling', () {
          late ThemeData themeData;

          setUp(() {
            themeData = IoCrosswordTheme().themeData;

            when(() => word.isSolved).thenReturn(true);
            when(() => word.solvedTimestamp).thenReturn(1);
          });

          testWidgets(
            'when word is solved by Dash',
            (tester) async {
              when(() => word.mascot).thenReturn(Mascots.dash);

              await tester.pumpApp(
                layout: IoLayoutData.large,
                Theme(
                  data: themeData,
                  child: BlocProvider<WordSelectionBloc>(
                    create: (_) => wordSelectionBloc,
                    child: const CrosswordBoardView(),
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

          testWidgets(
            'when word is solved by Sparky',
            (tester) async {
              when(() => word.mascot).thenReturn(Mascots.sparky);

              await tester.pumpApp(
                layout: IoLayoutData.large,
                Theme(
                  data: themeData,
                  child: BlocProvider<WordSelectionBloc>(
                    create: (_) => wordSelectionBloc,
                    child: const CrosswordBoardView(),
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
                    themeData.io.crosswordLetterTheme.sparky.backgroundColor,
                textStyle: themeData.io.crosswordLetterTheme.sparky.textStyle,
              );

              expect(actualStyle, equals(expectedStyle));
            },
          );

          testWidgets(
            'when word is solved by Dino',
            (tester) async {
              when(() => word.mascot).thenReturn(Mascots.dino);

              await tester.pumpApp(
                layout: IoLayoutData.large,
                Theme(
                  data: themeData,
                  child: BlocProvider<WordSelectionBloc>(
                    create: (_) => wordSelectionBloc,
                    child: const CrosswordBoardView(),
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
                    themeData.io.crosswordLetterTheme.dino.backgroundColor,
                textStyle: themeData.io.crosswordLetterTheme.dino.textStyle,
              );

              expect(actualStyle, equals(expectedStyle));
            },
          );

          testWidgets(
            'when word is solved by Android',
            (tester) async {
              when(() => word.mascot).thenReturn(Mascots.android);

              await tester.pumpApp(
                layout: IoLayoutData.large,
                Theme(
                  data: themeData,
                  child: BlocProvider<WordSelectionBloc>(
                    create: (_) => wordSelectionBloc,
                    child: const CrosswordBoardView(),
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
                    themeData.io.crosswordLetterTheme.android.backgroundColor,
                textStyle: themeData.io.crosswordLetterTheme.android.textStyle,
              );

              expect(actualStyle, equals(expectedStyle));
            },
          );
        });
      });

      testWidgets(
        'not shown when word is not solved and the word is being solved',
        (tester) async {
          when(() => word.isSolved).thenReturn(false);

          when(() => word.solvedTimestamp).thenReturn(1);
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.solving,
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
                child: const CrosswordBoardView(),
              ),
            ),
          );

          expect(find.byType(IoWord), findsNothing);
        },
      );
    });
  });
}
