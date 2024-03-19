import 'package:board_generator_playground/src/models/models.dart';
import 'package:equatable/equatable.dart';

/// {@template word_entry}
/// A word entry on the board.
/// {@endtemplate}
class WordEntry extends Equatable {
  /// {@macro word_entry}
  WordEntry({
    required this.word,
    required this.start,
    required this.direction,
  }) : end = direction == Direction.across
            ? start.shift(x: word.length - 1)
            : start.shift(y: word.length - 1);

  /// The word to add to the board.
  final String word;

  /// The location of the first letter of the word.
  final Location start;

  /// The location of the last letter of the word.
  final Location end;

  /// {@macro direction}
  final Direction direction;

  /// The surrounding locations of the word entry.
  ///
  /// For example:
  ///
  /// Consider the following board
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -3  -  -  -  -  -
  /// -2  -  -  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  ///  3  -  -  -  -  -
  /// ```
  ///
  /// The surrounding locations of the word "BUSH" are:
  /// (0, -3), (-1, -2), (-1, -1), (-1, 0), (-1, 1), (-1, 2), (0, 3), (1, 2),
  /// (1, 1), (1, 0), (1, -1) and (1, -2).
  ///
  /// If we label those surrounding locations with "*" we get:
  ///
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -3  -  -  *  -  -
  /// -2  -  *  B  *  S
  /// -1  -  *  E  *  -
  ///  0  -  *  H  *  -
  ///  1  -  *  A  *  -
  ///  2  -  *  N  *  -
  ///  3  -  -  *  -  -
  /// ```
  Set<Location> surroundings() {
    final prefix = direction == Direction.across
        ? start.copyWith(x: start.x - 1)
        : start.copyWith(y: start.y - 1);
    final suffix = direction == Direction.across
        ? start.copyWith(x: start.x + word.length)
        : start.copyWith(y: start.y + word.length);

    return <Location>{
      prefix,
      suffix,
      for (var i = 0; i < word.length; i++)
        direction == Direction.across
            ? Location(x: start.x + i, y: start.y - 1)
            : Location(x: start.x - 1, y: start.y + i),
      for (var i = 0; i < word.length; i++)
        direction == Direction.across
            ? Location(x: start.x + i, y: start.y + 1)
            : Location(x: start.x + 1, y: start.y + i),
    };
  }

  @override
  List<Object?> get props => [word, start, direction];
}
