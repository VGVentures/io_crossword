import 'package:board_generator_playground/src/models/models.dart';

/// {@template word_entry}
/// A word entry on the board.
/// {@endtemplate}
class WordEntry {
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
}
