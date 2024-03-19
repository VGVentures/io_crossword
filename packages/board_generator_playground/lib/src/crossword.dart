import 'package:board_generator_playground/src/models/models.dart';

/// {@template character_map}
/// Maps a [Location] to a character.
/// {@endtemplate}
typedef CharacterMap = Map<Location, String>;

/// The board for the crossword puzzle.
class Crossword {
  /// {@macro character_map}
  final CharacterMap characterMap = {};

  /// The origin of the coordinate system.
  ///
  /// The origin (0, 0) is the middle letter of the first word added to the
  /// board. The first word should have an odd number of letters.
  static const origin = Location(x: 0, y: 0);

  /// Adds a word to the board.
  void add(WordEntry entry) {
    final location = entry.location;
    final word = entry.word;
    final direction = entry.direction;

    for (var i = 0; i < word.length; i++) {
      final character = word[i];
      final newLocation = direction == Direction.across
          ? location.copyWith(x: location.x + i)
          : location.copyWith(y: location.y + i);

      characterMap[newLocation] = character;
    }
  }
}
