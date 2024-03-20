import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';

/// {@template crossword1}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2
/// -2  A  L  B  U  S
/// -1  -  -  E  -  -
///  0  -  -  H  -  -
///  1  -  -  A  -  -
///  2  -  -  N  -  -
/// ```
/// {@endtemplate}
class Crossword1 extends Crossword {
  /// {@macro crossword1}
  Crossword1() {
    add(
      WordEntry(
        word: 'behan',
        start: const Location(x: 0, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'albus',
        start: const Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );
  }
}

/// {@template crossword2}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2
/// -2  A  L  B  U  S
/// -1  -  -  E  -  -
///  0  -  -  H  -  -
///  1  -  -  A  -  -
///  2  -  -  N  O  W
/// ```
/// {@endtemplate}
class Crossword2 extends Crossword {
  /// {@macro crossword2}
  Crossword2() {
    add(
      WordEntry(
        word: 'behan',
        start: const Location(x: 0, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'albus',
        start: const Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );
    add(
      WordEntry(
        word: 'now',
        start: const Location(x: 0, y: 2),
        direction: Direction.across,
      ),
    );
  }
}

/// {@template crossword3}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2
/// -2  A  L  B  U  S
/// -1  -  -  E  -  -
///  0  -  -  H  -  -
///  1  -  N  A  N  -
///  2  -  -  N  O  W
/// ```
/// {@endtemplate}
class Crossword3 extends Crossword {
  /// {@macro crossword3}
  Crossword3() {
    add(
      WordEntry(
        word: 'behan',
        start: const Location(x: 0, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'albus',
        start: const Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );
    add(
      WordEntry(
        word: 'now',
        start: const Location(x: 0, y: 2),
        direction: Direction.across,
      ),
    );
    add(
      WordEntry(
        word: 'nan',
        start: const Location(x: -1, y: 1),
        direction: Direction.across,
      ),
    );
  }
}

/// {@template crossword4}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2
/// -2  A  L  B  U  S
/// -1  -  -  E  -  -
///  0  -  -  H  -  -
///  1  -  N  A  N  -
///  2  -  -  N  -  -
/// ```
/// {@endtemplate}
class Crossword4 extends Crossword {
  /// {@macro crossword4}
  Crossword4() {
    add(
      WordEntry(
        word: 'behan',
        start: const Location(x: 0, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'albus',
        start: const Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );

    add(
      WordEntry(
        word: 'nan',
        start: const Location(x: -1, y: 1),
        direction: Direction.across,
      ),
    );
  }
}
