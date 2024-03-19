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

  /// Determines if a new [entry] will be connected to the existing board.
  ///
  /// For example:
  ///
  /// Considering this board:
  ///
  /// ```
  /// - - - A L B U S
  /// - - - - - E - -
  /// - - - - - H - -
  /// - - - - - A - -
  /// - - - - - N - -
  /// ```
  ///
  /// Adding the word "SUN" down at the end of the word "ALBUS" would be
  /// connected:
  ///
  /// ```
  /// - - - A L B U S
  /// - - - - - E - U
  /// - - - - - H - N
  /// - - - - - A - -
  /// - - - - - N - -
  /// ```
  ///
  /// However, adding the word "SUN" at the bottom left corner would not be
  /// connected:
  ///
  /// ```
  /// - - - A L B U S
  /// - - - - - E - -
  /// S - - - - H - -
  /// U - - - - A - -
  /// N - - - - N - -
  /// ```
  bool isConnected(WordEntry entry) {
    throw UnimplementedError();
  }

  /// Determines all the connections for a new [entry].
  ///
  /// For example:
  ///
  /// Considering this board:
  ///
  /// ```
  /// - - - A L B U S
  /// - - - - - E - -
  /// - - - - - H - -
  /// - - - - - A - -
  /// - - - - - N - -
  /// ```
  ///
  /// Adding the word "USA down the "U" in "ALBUS" would have a total of
  /// 4 connections:
  ///
  /// ```
  /// - - - A L B U S
  /// - - - - - E S -
  /// - - - - - H A -
  /// - - - - - A - -
  /// - - - - - N - -
  /// ```
  Set<Location> connections(WordEntry entry) {
    throw UnimplementedError();
  }

  /// Whether the new [entry] overlaps an existing word.
  ///
  /// For example:
  ///
  /// Considering this board:
  ///
  /// ```
  /// - - - A L B U S
  /// - - - - - E - -
  /// - - - - - H - -
  /// - - - - - A - -
  /// - - - - - N - -
  /// ```
  ///
  /// Adding the word "USA" across to the right of the word "ALBUS" would
  /// overlap:
  ///
  /// ```
  /// U S A A L B U S
  /// - - - - - E - -
  /// - - - - - H - -
  /// - - - - - A - -
  /// - - - - - N - -
  /// ```
  ///
  /// However, adding the word "SUN" down at the end of the word "ALBUS" would
  /// not overlap:
  ///
  /// ```
  /// - - - A L B U S
  /// - - - - - E - U
  /// - - - - - H - N
  /// - - - - - A - -
  /// - - - - - N - -
  /// ```
  ///
  /// Overlaps are not allowed since they would create invalid words.
  bool overlaps(WordEntry entry) {
    throw UnimplementedError();
  }
}
