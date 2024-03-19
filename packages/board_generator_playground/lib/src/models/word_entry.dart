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

  @override
  List<Object?> get props => [word, location, direction];
}
