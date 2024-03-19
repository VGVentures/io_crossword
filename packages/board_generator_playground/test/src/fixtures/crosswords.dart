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
      const WordEntry(
        word: 'behan',
        location: Location(x: 0, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      const WordEntry(
        word: 'albus',
        location: Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );
  }
}
