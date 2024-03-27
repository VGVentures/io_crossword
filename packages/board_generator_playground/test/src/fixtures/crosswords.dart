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
  Crossword1({
    super.bounds,
    super.longestWordLength,
  }) {
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

/// {@template crossword5}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2  3  4  5  6  7
/// -2  A  L  B  U  S  -  -  -  -  -
/// -1  P  -  E  -  -  -  -  -  -  -
///  0  P  -  H  A  T  -  -  -  -  -
///  1  L  -  A  -  -  -  -  C  A  R
///  2  E  -  N  -  -  -  -  -  -  -
/// ```
/// {@endtemplate}
class Crossword5 extends Crossword {
  /// {@macro crossword5}
  Crossword5() {
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
        word: 'apple',
        start: const Location(x: -2, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'hat',
        start: Location.zero,
        direction: Direction.across,
      ),
    );

    add(
      WordEntry(
        word: 'car',
        start: const Location(x: 5, y: 1),
        direction: Direction.across,
      ),
    );
  }
}

/// {@template crossword6}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2  3  4  5   6   7   8   9   10  11
/// -2  O  R  C  H  A  R  D  B   A   N   K   C   O   M
/// -1  C  -  O  -  T  -  C  -   P   -   -   -   -   -
///  0  O  N  M  L  I  N  E  -   R   -   -   -   -   -
///  1  M  -  M  -  O  -  M  -   I   -   -   -   -   -
///  2  M  O  U  R  N  F  U  L   L   Y   -   -   -   -
///  3  U  -  N  -  A  -  -  -   -   -   -   -   -   -
///  4  N  E  I  L  L  S  V  I   L   L   E   -   -   -
///  5  -  -  -  -  -  -  -  -   -   -   -   -   -   -
/// ```
/// {@endtemplate}
class Crossword6 extends Crossword {
  /// {@macro crossword6}
  Crossword6() {
    add(
      WordEntry(
        word: 'orchardbankcom',
        start: const Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );

    add(
      WordEntry(
        word: 'onmline',
        start: const Location(x: -2, y: 0),
        direction: Direction.across,
      ),
    );

    add(
      WordEntry(
        word: 'mournfully',
        start: const Location(x: -2, y: 2),
        direction: Direction.across,
      ),
    );

    add(
      WordEntry(
        word: 'neillsville',
        start: const Location(x: -2, y: 4),
        direction: Direction.across,
      ),
    );

    add(
      WordEntry(
        word: 'communi',
        start: const Location(x: 0, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'ational',
        start: const Location(x: 4, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'ocommunity',
        start: const Location(x: -2, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'ational',
        start: const Location(x: 2, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'april',
        start: const Location(x: 6, y: -2),
        direction: Direction.down,
      ),
    );
  }
}

/// {@template crossword7}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2  3  4  5   6   7
/// -2  L  I  B  E  X  E  C  -   C   -
/// -1  -  N  -  D  -  -  I  N   E   R
///  0  -  N  -  U  N  D  P  -   S   -
///  1  -  -  -  C  -  -  I  -   S   -
/// ```
/// {@endtemplate}
class Crossword7 extends Crossword {
  /// {@macro crossword7}
  Crossword7() {
    add(
      WordEntry(
        word: 'libexec',
        start: const Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );

    add(
      WordEntry(
        word: 'inn',
        start: const Location(x: -1, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'educ',
        start: const Location(x: 1, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'undp',
        start: const Location(x: 1, y: 0),
        direction: Direction.across,
      ),
    );

    ///    -2 -1  0  1  2  3  4  5   6   7
    /// -2  L  I  B  E  X  E  C  -   C   -
    /// -1  -  N  -  D  -  -  I  N   E   R
    ///  0  -  N  -  U  N  D  P  -   S   -
    ///  1  -  -  -  C  -  -  I  -   S   -

    add(
      WordEntry(
        word: 'cipi',
        start: const Location(x: 4, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'cess',
        start: const Location(x: 6, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'iner',
        start: const Location(x: 4, y: -1),
        direction: Direction.across,
      ),
    );
  }
}

/// {@template crossword8}
/// A pre-defined crossword for testing.
///
/// ```
///     -6 -5 -4 -3 -2 -1  0  1  2
/// -2   S  U  P  E  R  M  A  N  -
/// -1   O  -  -  -  -  -  -  E  -
///  0   S  -  -  -  -  M  O  M  -
///  1   -  -  -  -  -  -  -  O  -
///  2   -  -  -  -  -  -  -  S  -
/// ```
/// {@endtemplate}
class Crossword8 extends Crossword {
  /// {@macro crossword8}
  Crossword8() {
    add(
      WordEntry(
        word: 'superman',
        start: const Location(x: -6, y: -2),
        direction: Direction.across,
      ),
    );
    add(
      WordEntry(
        word: 'sos',
        start: const Location(x: -6, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'nemos',
        start: const Location(x: 1, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'mom',
        start: const Location(x: -1, y: 0),
        direction: Direction.across,
      ),
    );
  }
}

/// {@template crossword9}
/// A pre-defined crossword for testing.
///
/// ```
///     -6 -5 -4 -3 -2 -1  0  1  2  3  4  5  6  7  8  9  10  11  12  13  14  15
/// -2   -  -  E  -  I  N  T  E  R  C  H  A  N  G  E  A  B   I   L   I   T   Y
/// -1   I  -  N  -  O  -  -  -  -  -  -  -  -  -  -  -  -   -   -   -   -   -
///  0   N  -  D  -  N  E  U  R  O  D  E  V  E  L  O  P  M   E   N   T   A   L
///  1   -  -  -  -  -  -  -  -  -
/// ```
/// {@endtemplate}
class Crossword9 extends Crossword {
  /// {@macro crossword9}
  Crossword9() {
    add(
      WordEntry(
        word: 'interchangeability',
        start: const Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );
    add(
      WordEntry(
        word: 'neurodevelopmental',
        start: const Location(x: -2, y: 0),
        direction: Direction.across,
      ),
    );
    add(
      WordEntry(
        word: 'in',
        start: const Location(x: -6, y: -1),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'end',
        start: const Location(x: -4, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'ion',
        start: const Location(x: -2, y: -2),
        direction: Direction.down,
      ),
    );
  }
}

/// {@template crossword8}
/// A pre-defined crossword for testing.
///
/// ```
///      1  2  3  4  5  6  7  8  9  10  11  12  13  14  15  16  17  18  19
/// -2   S  -  -  -  -  -  -  -  -  -   -   -   -   -   -   -   -   -   C
/// -1   O  -  -  -  -  -  -  -  -  -   -   -   -   -   -   -   -   -   A
///  0   S  -  -  -  -  -  -  -  -  -   -   -   -   -   -   -   -   V   -
///  1   -  -  -  -  -  -  -  -  -  -   -   -   -   -   -   -   -   A   -
///  2   -  -  -  -  -  -  -  -  -  -   -   -   -   -   -   -   -   N   -
/// ```
/// {@endtemplate}
class Crossword10 extends Crossword {
  /// {@macro crossword8}
  Crossword10() {
    add(
      WordEntry(
        word: 'sos',
        start: const Location(x: 1, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'ca',
        start: const Location(x: 19, y: -2),
        direction: Direction.down,
      ),
    );

    add(
      WordEntry(
        word: 'van',
        start: const Location(x: 18, y: 0),
        direction: Direction.down,
      ),
    );
  }
}
