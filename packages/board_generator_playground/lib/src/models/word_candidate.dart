import 'package:board_generator_playground/src/models/models.dart';
import 'package:equatable/equatable.dart';

/// {@template word_candidate}
/// A candidate for a word to be placed on the board.
/// {@endtemplate}
class WordCandidate extends Equatable {
  /// {@macro word_candidate}
  const WordCandidate({
    required this.location,
    required this.direction,
  });

  /// The location of the start of the word on the board.
  final Location location;

  /// The direction of the word.
  final Direction direction;

  @override
  List<Object?> get props => [location, direction];
}

/// {@template constrained_word_candidate}
/// A candidate for a word to be placed on the board with constraints.
/// {@endtemplate}
class ConstrainedWordCandidate extends WordCandidate {
  /// {@macro constrained_word_candidate}
  const ConstrainedWordCandidate({
    required this.maximumLength,
    required super.location,
    required super.direction,
    required this.constraints,
  });

  /// The maximum length this word can be.
  final int maximumLength;

  /// The constraints for this word.
  ///
  /// For example:
  ///
  /// ```dart
  /// {1:'a', 3:'b'}
  /// ```
  /// Means the second character must be an 'a' and the fourth character must be
  /// a 'b'.
  final Map<int, String> constraints;

  @override
  List<Object?> get props => [
        ...super.props,
        maximumLength,
        constraints,
      ];
}
