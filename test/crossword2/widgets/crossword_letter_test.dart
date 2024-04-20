// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart' hide Axis;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/crossword2/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixtures.dart';
import '../../helpers/helpers.dart';

class _MockWord extends Mock implements Word {}

void main() {
  group('$CrosswordLetter', () {
    const ant = Word(
      id: '1',
      position: Point<int>(0, 0),
      axis: Axis.horizontal,
      length: 3,
      clue: '',
    );

    late CrosswordLayoutData crosswordLayoutData;

    setUp(() {
      crosswordLayoutData = CrosswordLayoutData.fromConfiguration(
        configuration: const CrosswordConfiguration(
          bottomLeft: (40, 40),
          chunkSize: 20,
        ),
        cellSize: const Size.square(20),
      );
    });

    testWidgets('pumps text character is known', (tester) async {
      final knownLetterData = CrosswordLetterData(
        index: (0, 0),
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
  });

  group('$CrosswordLetterData', () {
    test('can be instantiated', () {
      expect(
        CrosswordLetterData(
          index: (0, 0),
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
        character: 'A',
        words: (word, word),
      );
      final letter2 = CrosswordLetterData(
        index: (0, 0),
        character: 'A',
        words: (word, word),
      );
      final letter3 = CrosswordLetterData(
        index: (0, 0),
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

        final letters = CrosswordLetterData.fromChunk(chunk);

        final hello = chunk.words.firstWhere((word) => word.answer == 'HELLO');
        final old = chunk.words.firstWhere((word) => word.answer == 'OLD');
        final food = chunk.words.firstWhere((word) => word.answer == 'FOOD');
        final elf = chunk.words.firstWhere((word) => word.answer == 'ELF');
        final unknown = chunk.words.firstWhere((word) => word.answer == null);

        expect(
          letters,
          equals({
            (0, 0): CrosswordLetterData(
              index: (0, 0),
              character: 'H',
              words: (hello, null),
            ),
            (1, 0): CrosswordLetterData(
              index: (1, 0),
              character: 'E',
              words: (hello, elf),
            ),
            (2, 0): CrosswordLetterData(
              index: (2, 0),
              character: 'L',
              words: (hello, null),
            ),
            (3, 0): CrosswordLetterData(
              index: (3, 0),
              character: 'L',
              words: (hello, null),
            ),
            (4, 0): CrosswordLetterData(
              index: (4, 0),
              character: 'O',
              words: (hello, old),
            ),
            (1, 1): CrosswordLetterData(
              index: (1, 1),
              character: 'L',
              words: (null, elf),
            ),
            (4, 1): CrosswordLetterData(
              index: (4, 1),
              character: 'L',
              words: (null, old),
            ),
            (1, 2): CrosswordLetterData(
              index: (1, 2),
              character: 'F',
              words: (food, elf),
            ),
            (2, 2): CrosswordLetterData(
              index: (2, 2),
              character: 'O',
              words: (food, unknown),
            ),
            (3, 2): CrosswordLetterData(
              index: (3, 2),
              character: 'O',
              words: (food, null),
            ),
            (4, 2): CrosswordLetterData(
              index: (4, 2),
              character: 'D',
              words: (food, old),
            ),
            (2, 3): CrosswordLetterData(
              index: (2, 3),
              character: null,
              words: (null, unknown),
            ),
            (2, 4): CrosswordLetterData(
              index: (2, 4),
              character: null,
              words: (null, unknown),
            ),
          }),
        );
      });
    });
  });
}
