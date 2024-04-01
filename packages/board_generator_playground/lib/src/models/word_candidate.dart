import 'package:board_generator_playground/board_generator_playground.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:equatable/equatable.dart';

/// {@template word_candidate}
/// A candidate for a word to be placed on the board.
/// {@endtemplate}
class WordCandidate extends Equatable {
  /// {@macro word_candidate}
  const WordCandidate({
    required this.start,
    required this.direction,
  });

  /// The location of the start of the word on the board.
  final Location start;

  /// The direction of the word.
  final Direction direction;

  /// Fixes the length of the word candidate.
  FixedLengthWordCandidate fixTo(int length) {
    return FixedLengthWordCandidate(
      length: length,
      start: start,
      direction: direction,
    );
  }

  @override
  List<Object?> get props => [start, direction];
}

/// {@template constrained_word_candidate}
/// A candidate for a word to be placed on the board with constraints.
/// {@endtemplate}
class ConstrainedWordCandidate extends WordCandidate {
  /// {@macro constrained_word_candidate}
  const ConstrainedWordCandidate({
    required this.invalidLengths,
    required super.start,
    required super.direction,
    required this.constraints,
  });

  /// The lengths that the word cannot be.
  final Set<int> invalidLengths;

  /// The constraints for this word.
  ///
  /// For example:
  ///
  /// ```dart
  /// {1:'a', 3:'b'}
  /// ```
  ///
  /// Means the second character must be an 'a' and the fourth character must be
  /// a 'b'.
  final Map<int, String> constraints;

  /// Whether the word satisfies the constraints.
  bool satisfies(String word) {
    if (invalidLengths.contains(word.length)) {
      return false;
    }

    for (final i in constraints.keys.where((index) => index < word.length)) {
      if (word[i].toLowerCase() != constraints[i]!.toLowerCase()) {
        return false;
      }
    }

    return true;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        invalidLengths,
        constraints,
      ];
}

/// {@template fixed_length_word_candidate}
/// A candidate for a word to be placed on the board with a fixed length.
/// {@endtemplate}
class FixedLengthWordCandidate extends WordCandidate {
  /// {@macro fixed_length_word_candidate}
  FixedLengthWordCandidate({
    required this.length,
    required super.start,
    required super.direction,
  }) : end = direction == Direction.across
            ? start.shift(x: length - 1)
            : start.shift(y: length - 1);

  /// The length of the word.
  final int length;

  /// The location of the last letter of the word.
  final Location end;

  /// The prefix of the word entry.
  Location get prefix =>
      direction == Direction.across ? start.left() : start.up();

  /// The suffix of the word entry.
  Location get suffix =>
      direction == Direction.across ? end.right() : end.down();

  /// The surrounding locations of the word entry.
  ///
  /// For example, consider the following board:
  ///
  /// ```
  ///    -1  0  1  2
  /// -3  -  -  -  -
  /// -2  -  B  U  S
  /// -1  -  E  -  -
  ///  0  -  H  -  -
  ///  1  -  A  -  -
  ///  2  -  N  -  -
  ///  3  -  -  -  -
  /// ```
  ///
  /// The surrounding locations of the word "BEHAN" are:
  /// (0, -3), (-1, -2), (-1, -1), (-1, 0), (-1, 1), (-1, 2), (0, 3), (1, 2),
  /// (1, 1), (1, 0), (1, -1) and (1, -2).
  ///
  /// If we label those surrounding locations with "*" we get:
  ///
  ///
  /// ```
  ///    -1  0  1  2
  /// -3  -  *  -  -
  /// -2  *  B  *  S
  /// -1  *  E  *  -
  ///  0  *  H  *  -
  ///  1  *  A  *  -
  ///  2  *  N  *  -
  ///  3  -  *  -  -
  /// ```
  Set<Location> surroundings() {
    return {
      prefix,
      suffix,
      for (var i = 0; i < length; i++)
        direction == Direction.across
            ? start.shift(x: i, y: -1)
            : start.shift(x: -1, y: i),
      for (var i = 0; i < length; i++)
        direction == Direction.across
            ? start.shift(x: i, y: 1)
            : start.shift(x: 1, y: i),
    };
  }

  @override
  List<Object?> get props => [
        ...super.props,
        length,
      ];
}

/// {@template word_entry}
/// A word entry on the board.
/// {@endtemplate}
class WordEntry extends FixedLengthWordCandidate {
  /// {@macro word_entry}
  WordEntry({
    required this.word,
    required super.start,
    required super.direction,
  }) : super(
          length: word.length,
        );

  /// The word to add to the board.
  final String word;

  @override
  List<Object?> get props => [...super.props, word];
}
