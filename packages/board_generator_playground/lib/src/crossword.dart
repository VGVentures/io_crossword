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
    final location = entry.location;
    final word = entry.word;
    final direction = entry.direction;

    for (var i = 0; i < word.length; i++) {
      final newLocation = direction == Direction.across
          ? location.copyWith(x: location.x + i)
          : location.copyWith(y: location.y + i);

      if (characterMap[newLocation] != null) {
        return true;
      }
    }

    return false;
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
    final location = entry.location;
    final word = entry.word;
    final direction = entry.direction;

    final positions = <Location>[];

    for (var i = 0; i < word.length; i++) {
      final x = location.x + i;
      final y = location.y + i;

      final isFirstCharacter = i == 0;
      final isLastCharacter = i >= word.length;

      switch (direction) {
        case Direction.across:
          positions.addAll(
            [
              location.copyWith(y: y - 1),
              location.copyWith(y: y + 1),
              if (isFirstCharacter) location.copyWith(x: x - 1),
              if (isLastCharacter) location.copyWith(x: x + 1),
            ],
          );
        case Direction.down:
          positions.addAll(
            [
              location.copyWith(x: x - 1),
              location.copyWith(x: x + 1),
              if (isFirstCharacter) location.copyWith(y: y - 1),
              if (isLastCharacter) location.copyWith(y: y + 1),
            ],
          );
      }
    }

    final connections = <Location>{};
    for (final position in positions) {
      if (characterMap[position] != null) {
        connections.add(position);
      }
    }

    return connections;
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
    final location = entry.location;
    final word = entry.word;
    final direction = entry.direction;

    for (var i = 0; i < word.length; i++) {
      switch (direction) {
        case Direction.across:
          final x = location.x + i;

          // Before
          if (characterMap[location.copyWith(x: x - 1)] != null) {
            if (characterMap[location.copyWith(x: x - 2)] != null) {
              return true;
            }
          }

          // Current
          if (characterMap[location.copyWith(x: x - 1)])
          // After
          if (characterMap[location.copyWith(x: x + 1)] != null) {
            if (characterMap[location.copyWith(x: x + 2)] != null) {
              return true;
            }
          }
        case Direction.down:
      }
    }

    return false;
  }
}
