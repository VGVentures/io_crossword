import 'package:game_domain/game_domain.dart';

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
///
BoardSection get chunkFixture1 {
  const hello = Word(
    id: '1',
    answer: 'HELLO',
    position: Point<int>(0, 0),
    axis: Axis.horizontal,
    length: 5,
    clue: '',
  );
  const old = Word(
    id: '2',
    answer: 'OLD',
    position: Point<int>(4, 0),
    axis: Axis.vertical,
    length: 3,
    clue: '',
  );
  const food = Word(
    id: '3',
    answer: 'FOOD',
    position: Point<int>(1, 2),
    axis: Axis.horizontal,
    length: 4,
    clue: '',
  );
  const elf = Word(
    id: '4',
    answer: 'ELF',
    position: Point<int>(1, 0),
    axis: Axis.vertical,
    length: 3,
    clue: '',
  );
  const unknown = Word(
    id: '5',
    position: Point<int>(2, 2),
    axis: Axis.vertical,
    length: 3,
    clue: '',
  );

  return const BoardSection(
    id: '1',
    position: Point<int>(0, 0),
    words: [hello, old, food, elf, unknown],
    size: 20,
    borderWords: [],
  );
}
