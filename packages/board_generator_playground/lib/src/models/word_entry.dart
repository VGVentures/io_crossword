import 'package:board_generator_playground/src/models/models.dart';
import 'package:equatable/equatable.dart';

/// {@template word_entry}
/// A word entry on the board.
/// {@endtemplate}
class WordEntry extends Equatable {
  /// {@macro word_entry}
  const WordEntry({
    required this.word,
    required this.location,
    required this.direction,
  });

  /// The word to add to the board.
  final String word;

  /// {@macro location}
  final Location location;

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
        ? location.copyWith(x: location.x - 1)
        : location.copyWith(y: location.y - 1);
    final suffix = direction == Direction.across
        ? location.copyWith(x: location.x + word.length)
        : location.copyWith(y: location.y + word.length);

    return <Location>{
      prefix,
      suffix,
      for (var i = 0; i < word.length; i++)
        direction == Direction.across
            ? Location(x: location.x + i, y: location.y - 1)
            : Location(x: location.x - 1, y: location.y + i),
      for (var i = 0; i < word.length; i++)
        direction == Direction.across
            ? Location(x: location.x + i, y: location.y + 1)
            : Location(x: location.x + 1, y: location.y + i),
    };
  }

  @override
  List<Object?> get props => [word, location, direction];
}
