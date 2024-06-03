import 'package:game_domain/game_domain.dart';

/// A fixture for a [BoardSection] instance.
///
/// ```
///   -1 0 1 2 3 4
///  0 - H E L L O
///  1 - - L - - L
///  2 - - F O O D
///  3 - - - ? - -
///  4 P O L O - -
/// ```
///
BoardSection get chunkFixture1 {
  const polo = Word(
    id: '0',
    answer: 'POLO',
    position: Point<int>(-1, 4),
    axis: WordAxis.horizontal,
    clue: '',
  );
  const hello = Word(
    id: '1',
    answer: 'HELLO',
    position: Point<int>(0, 0),
    axis: WordAxis.horizontal,
    clue: '',
    solvedTimestamp: 123,
  );
  const old = Word(
    id: '2',
    answer: 'OLD',
    position: Point<int>(4, 0),
    axis: WordAxis.vertical,
    clue: '',
    solvedTimestamp: 123,
  );
  const food = Word(
    id: '3',
    answer: 'FOOD',
    position: Point<int>(1, 2),
    axis: WordAxis.horizontal,
    clue: '',
    solvedTimestamp: 123,
  );
  const elf = Word(
    id: '4',
    answer: 'ELF',
    position: Point<int>(1, 0),
    axis: WordAxis.vertical,
    clue: '',
    solvedTimestamp: 123,
  );
  final unknown = Word(
    id: '5',
    answer: Word.emptyCharacter * 3,
    position: const Point<int>(2, 2),
    axis: WordAxis.vertical,
    clue: '',
  );

  return BoardSection(
    id: '1',
    position: const Point<int>(0, 0),
    words: [polo, hello, old, food, elf, unknown],
  );
}
