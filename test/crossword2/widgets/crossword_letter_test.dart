// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart' hide Axis;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/crossword2/widgets/widgets.dart';
import 'package:mocktail/mocktail.dart';

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
        final boardSection = _boardSectionFixture;

        final letters = CrosswordLetterData.fromChunk(boardSection);

        final hello =
            boardSection.words.firstWhere((word) => word.answer == 'HELLO');
        final old =
            boardSection.words.firstWhere((word) => word.answer == 'OLD');
        final food =
            boardSection.words.firstWhere((word) => word.answer == 'FOOD');
        final elf =
            boardSection.words.firstWhere((word) => word.answer == 'ELF');
        final unknown =
            boardSection.words.firstWhere((word) => word.answer == null);

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

/// A fixture for a [BoardSection] instance.
///
/// ```
///   0 1 2 3 4
/// 0 H E L L O
/// 1 - L - - L
/// 2 - F O O D
/// 3 - - ? - -
/// 4 - - ? - -
/// ```
final _boardSectionFixture = () {
  final hello = Word(
    id: '1',
    answer: 'HELLO',
    position: Point<int>(0, 0),
    axis: Axis.horizontal,
    length: 5,
    clue: '',
  );
  final old = Word(
    id: '2',
    answer: 'OLD',
    position: Point<int>(4, 0),
    axis: Axis.vertical,
    length: 3,
    clue: '',
  );
  final food = Word(
    id: '3',
    answer: 'FOOD',
    position: Point<int>(1, 2),
    axis: Axis.horizontal,
    length: 4,
    clue: '',
  );
  final elf = Word(
    id: '4',
    answer: 'ELF',
    position: Point<int>(1, 0),
    axis: Axis.vertical,
    length: 3,
    clue: '',
  );
  final unknown = Word(
    id: '5',
    position: Point<int>(2, 2),
    axis: Axis.vertical,
    length: 3,
    clue: '',
  );

  return BoardSection(
    id: '1',
    position: Point<int>(0, 0),
    words: [hello, old, food, elf, unknown],
    size: 20,
    borderWords: const [],
  );
}();
