// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixtures.dart';
import '../../helpers/helpers.dart';

class _MockWord extends Mock implements Word {}

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

void main() {
  group('$CrosswordLetter', () {
    final ant = Word(
      id: '1',
      position: Point<int>(0, 0),
      answer: Word.emptyCharacter * 3,
      axis: WordAxis.horizontal,
      clue: '',
    );

    late CrosswordLayoutData crosswordLayoutData;

    setUp(() {
      crosswordLayoutData = CrosswordLayoutData.fromConfiguration(
        configuration: const CrosswordConfiguration(
          bottomRight: (40, 40),
          chunkSize: 20,
        ),
        cellSize: const Size.square(20),
        padding: const EdgeInsets.all(20),
      );
    });

    testWidgets('pumps text character if known', (tester) async {
      final knownLetterData = CrosswordLetterData(
        index: (0, 0),
        chunkIndex: (0, 0),
        character: 'A',
        words: (ant, null),
      );
      await tester.pumpApp(
        CrosswordLayoutScope(
          data: crosswordLayoutData,
          child: CrosswordLetter(data: knownLetterData),
        ),
      );

      expect(find.byType(CrosswordLetter), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('does not pump text when character is unknown', (tester) async {
      final unknownLetterData = CrosswordLetterData(
        index: (0, 0),
        chunkIndex: (0, 0),
        character: null,
        words: (ant, null),
      );
      await tester.pumpApp(
        CrosswordLayoutScope(
          data: crosswordLayoutData,
          child: CrosswordLetter(data: unknownLetterData),
        ),
      );

      expect(find.byType(CrosswordLetter), findsOneWidget);
      expect(find.text('A'), findsNothing);
    });

    testWidgets('emits $LetterSelected when tapped', (tester) async {
      final wordSelectionBloc = _MockWordSelectionBloc();

      final letterData = CrosswordLetterData(
        index: (0, 0),
        chunkIndex: (0, 0),
        character: 'A',
        words: (ant, null),
      );

      await tester.pumpApp(
        BlocProvider<WordSelectionBloc>(
          create: (_) => wordSelectionBloc,
          child: CrosswordLayoutScope(
            data: crosswordLayoutData,
            child: CrosswordLetter(data: letterData),
          ),
        ),
      );

      await tester.tap(find.byType(CrosswordLetter));

      verify(() => wordSelectionBloc.add(LetterSelected(letter: letterData)))
          .called(1);
    });

    group('styles', () {
      late ThemeData themeData;

      setUp(() {
        themeData = IoCrosswordTheme().themeData;
      });

      testWidgets(
        'with horizontal word mascot when solved and vertical is null',
        (tester) async {
          final word = ant.copyWith(
            mascot: Mascot.android,
            solvedTimestamp: 1,
          );
          final letterData = CrosswordLetterData(
            index: (0, 0),
            chunkIndex: (0, 0),
            character: 'A',
            words: (word, null),
          );

          await tester.pumpApp(
            Theme(
              data: themeData,
              child: CrosswordLayoutScope(
                data: crosswordLayoutData,
                child: CrosswordLetter(data: letterData),
              ),
            ),
          );

          final ioCrosswordLetterFinder = find.byType(IoCrosswordLetter);
          final ioCrosswordLetter =
              tester.widget<IoCrosswordLetter>(ioCrosswordLetterFinder);
          final style = ioCrosswordLetter.style;

          expect(style, equals(themeData.io.crosswordLetterTheme.android));
        },
      );

      testWidgets(
        'with vertical word mascot when solved and horizontal is null',
        (tester) async {
          final word = ant.copyWith(
            mascot: Mascot.dash,
            solvedTimestamp: 1,
          );
          final letterData = CrosswordLetterData(
            index: (0, 0),
            chunkIndex: (0, 0),
            character: 'A',
            words: (null, word),
          );

          await tester.pumpApp(
            Theme(
              data: themeData,
              child: CrosswordLayoutScope(
                data: crosswordLayoutData,
                child: CrosswordLetter(data: letterData),
              ),
            ),
          );

          final ioCrosswordLetterFinder = find.byType(IoCrosswordLetter);
          final ioCrosswordLetter =
              tester.widget<IoCrosswordLetter>(ioCrosswordLetterFinder);
          final style = ioCrosswordLetter.style;

          expect(style, equals(themeData.io.crosswordLetterTheme.dash));
        },
      );

      testWidgets(
        'with horizontal word mascot when solved before vertical word',
        (tester) async {
          final horizontalWord =
              ant.copyWith(mascot: Mascot.sparky, solvedTimestamp: 1);
          final verticalWord =
              ant.copyWith(mascot: Mascot.dino, solvedTimestamp: 2);
          final letterData = CrosswordLetterData(
            index: (0, 0),
            chunkIndex: (0, 0),
            character: 'A',
            words: (horizontalWord, verticalWord),
          );

          await tester.pumpApp(
            Theme(
              data: themeData,
              child: CrosswordLayoutScope(
                data: crosswordLayoutData,
                child: CrosswordLetter(data: letterData),
              ),
            ),
          );

          final ioCrosswordLetterFinder = find.byType(IoCrosswordLetter);
          final ioCrosswordLetter =
              tester.widget<IoCrosswordLetter>(ioCrosswordLetterFinder);
          final style = ioCrosswordLetter.style;

          expect(style, equals(themeData.io.crosswordLetterTheme.sparky));
        },
      );

      testWidgets(
        'with vertical word mascot when solved before horizontal word',
        (tester) async {
          final horizontalWord =
              ant.copyWith(mascot: Mascot.sparky, solvedTimestamp: 2);
          final verticalWord =
              ant.copyWith(mascot: Mascot.dino, solvedTimestamp: 1);
          final letterData = CrosswordLetterData(
            index: (0, 0),
            chunkIndex: (0, 0),
            character: 'A',
            words: (horizontalWord, verticalWord),
          );

          await tester.pumpApp(
            Theme(
              data: themeData,
              child: CrosswordLayoutScope(
                data: crosswordLayoutData,
                child: CrosswordLetter(data: letterData),
              ),
            ),
          );

          final ioCrosswordLetterFinder = find.byType(IoCrosswordLetter);
          final ioCrosswordLetter =
              tester.widget<IoCrosswordLetter>(ioCrosswordLetterFinder);
          final style = ioCrosswordLetter.style;

          expect(style, equals(themeData.io.crosswordLetterTheme.dino));
        },
      );

      testWidgets(
        'with empty style when both have not been solved',
        (tester) async {
          final horizontalWord = ant.copyWith(mascot: Mascot.dash);
          final verticalWord = ant.copyWith(mascot: Mascot.dino);
          final letterData = CrosswordLetterData(
            index: (0, 0),
            chunkIndex: (0, 0),
            character: 'A',
            words: (horizontalWord, verticalWord),
          );

          await tester.pumpApp(
            Theme(
              data: themeData,
              child: CrosswordLayoutScope(
                data: crosswordLayoutData,
                child: CrosswordLetter(data: letterData),
              ),
            ),
          );

          final ioCrosswordLetterFinder = find.byType(IoCrosswordLetter);
          final ioCrosswordLetter =
              tester.widget<IoCrosswordLetter>(ioCrosswordLetterFinder);
          final style = ioCrosswordLetter.style;

          expect(style, equals(themeData.io.crosswordLetterTheme.empty));
        },
      );

      testWidgets(
        'with horizontal word mascot when both have the same timestamp',
        (tester) async {
          final horizontalWord =
              ant.copyWith(mascot: Mascot.dash, solvedTimestamp: 1);
          final verticalWord =
              ant.copyWith(mascot: Mascot.dino, solvedTimestamp: 1);
          final letterData = CrosswordLetterData(
            index: (0, 0),
            chunkIndex: (0, 0),
            character: 'A',
            words: (horizontalWord, verticalWord),
          );

          await tester.pumpApp(
            Theme(
              data: themeData,
              child: CrosswordLayoutScope(
                data: crosswordLayoutData,
                child: CrosswordLetter(data: letterData),
              ),
            ),
          );

          final ioCrosswordLetterFinder = find.byType(IoCrosswordLetter);
          final ioCrosswordLetter =
              tester.widget<IoCrosswordLetter>(ioCrosswordLetterFinder);
          final style = ioCrosswordLetter.style;

          expect(style, equals(themeData.io.crosswordLetterTheme.dash));
        },
      );
    });
  });

  group('$CrosswordLetterData', () {
    test('can be instantiated', () {
      expect(
        CrosswordLetterData(
          index: (0, 0),
          chunkIndex: (0, 0),
          character: 'A',
          words: (null, null),
        ),
        isA<CrosswordLetterData>(),
      );
    });

    test('supports value equality', () {
      final word = _MockWord();
      final letter1 = CrosswordLetterData(
        index: (0, 0),
        chunkIndex: (0, 0),
        character: 'A',
        words: (word, word),
      );
      final letter2 = CrosswordLetterData(
        index: (0, 0),
        chunkIndex: (0, 0),
        character: 'A',
        words: (word, word),
      );
      final letter3 = CrosswordLetterData(
        index: (1, 1),
        chunkIndex: (1, 1),
        character: 'B',
        words: (null, null),
      );

      expect(letter1, equals(letter2));
      expect(letter1, isNot(equals(letter3)));
      expect(letter2, isNot(equals(letter3)));
    });

    group('fromChunk', () {
      test('derives letters as expected', () {
        final chunk = chunkFixture1;
        final chunkIndex = (chunk.position.x, chunk.position.y);

        final letters = CrosswordLetterData.fromChunk(chunk);

        final polo = chunk.words.firstWhere((word) => word.id == '0');
        final hello = chunk.words.firstWhere((word) => word.id == '1');
        final old = chunk.words.firstWhere((word) => word.id == '2');
        final food = chunk.words.firstWhere((word) => word.id == '3');
        final elf = chunk.words.firstWhere((word) => word.id == '4');
        final unknown = chunk.words.firstWhere((word) => word.id == '5');

        expect(
          letters,
          equals({
            (0, 0): CrosswordLetterData(
              index: (0, 0),
              chunkIndex: chunkIndex,
              character: 'H',
              words: (hello, null),
            ),
            (1, 0): CrosswordLetterData(
              index: (1, 0),
              chunkIndex: chunkIndex,
              character: 'E',
              words: (hello, elf),
            ),
            (2, 0): CrosswordLetterData(
              index: (2, 0),
              chunkIndex: chunkIndex,
              character: 'L',
              words: (hello, null),
            ),
            (3, 0): CrosswordLetterData(
              index: (3, 0),
              chunkIndex: chunkIndex,
              character: 'L',
              words: (hello, null),
            ),
            (4, 0): CrosswordLetterData(
              index: (4, 0),
              chunkIndex: chunkIndex,
              character: 'O',
              words: (hello, old),
            ),
            (1, 1): CrosswordLetterData(
              index: (1, 1),
              chunkIndex: chunkIndex,
              character: 'L',
              words: (null, elf),
            ),
            (4, 1): CrosswordLetterData(
              index: (4, 1),
              chunkIndex: chunkIndex,
              character: 'L',
              words: (null, old),
            ),
            (1, 2): CrosswordLetterData(
              index: (1, 2),
              chunkIndex: chunkIndex,
              character: 'F',
              words: (food, elf),
            ),
            (2, 2): CrosswordLetterData(
              index: (2, 2),
              chunkIndex: chunkIndex,
              character: 'O',
              words: (food, unknown),
            ),
            (3, 2): CrosswordLetterData(
              index: (3, 2),
              chunkIndex: chunkIndex,
              character: 'O',
              words: (food, null),
            ),
            (4, 2): CrosswordLetterData(
              index: (4, 2),
              chunkIndex: chunkIndex,
              character: 'D',
              words: (food, old),
            ),
            (2, 3): CrosswordLetterData(
              index: (2, 3),
              chunkIndex: chunkIndex,
              character: ' ',
              words: (null, unknown),
            ),
            (-1, 4): CrosswordLetterData(
              index: (-1, 4),
              chunkIndex: chunkIndex,
              character: 'P',
              words: (polo, null),
            ),
            (0, 4): CrosswordLetterData(
              index: (0, 4),
              chunkIndex: chunkIndex,
              character: 'O',
              words: (polo, null),
            ),
            (1, 4): CrosswordLetterData(
              index: (1, 4),
              chunkIndex: chunkIndex,
              character: 'L',
              words: (polo, null),
            ),
            (2, 4): CrosswordLetterData(
              index: (2, 4),
              chunkIndex: chunkIndex,
              character: 'O',
              words: (polo, unknown),
            ),
          }),
        );
      });
    });
  });
}
