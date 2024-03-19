import 'package:board_generator_playground/src/models/models.dart';
import 'package:equatable/equatable.dart';

/// {@template character_map}
/// Maps a [Location] to a [CharacterData].
/// {@endtemplate}
typedef CharacterMap = Map<Location, CharacterData>;

/// {@template character_data}
/// The data for a character on the board.
/// {@endtemplate}
class CharacterData extends Equatable {
  /// {@macro character_data}
  const CharacterData({
    required this.character,
    required this.wordEntry,
  });

  /// The character.
  final String character;

  /// The words that contain this character.
  final Set<WordEntry> wordEntry;

  @override
  List<Object?> get props => [character, wordEntry];
}

/// The board for the crossword puzzle.
class Crossword {
  /// {@macro character_map}
  final CharacterMap characterMap = {};

  static const largestWordLength = 18;

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

      final data = (characterMap[newLocation]?..wordEntry.add(entry)) ??
          CharacterData(character: character, wordEntry: {entry});
      characterMap[newLocation] = data;
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
  /// Adding the word "USA" down the "U" in "ALBUS" would have a total of
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
      final isFirstCharacter = i == 0;
      final isLastCharacter = i >= word.length;

      switch (direction) {
        case Direction.across:
          final x = location.x + i;
          final y = location.y;

          positions.addAll(
            [
              Location(x: x, y: y - 1),
              Location(x: x, y: y + 1),
              if (isFirstCharacter) Location(x: x - 1, y: y),
              if (isLastCharacter) Location(x: x + 1, y: y),
            ],
          );
        case Direction.down:
          final x = location.x;
          final y = location.y + i;

          positions.addAll(
            [
              Location(x: x - 1, y: y),
              Location(x: x + 1, y: y),
              if (isFirstCharacter) Location(x: x, y: y - 1),
              if (isLastCharacter) Location(x: x, y: y + 1),
            ],
          );
      }
    }

    return {
      for (final position in positions)
        if (characterMap[position] != null) position,
    };
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
  /// Overlaps are not allowed since they would create invalid words or
  /// completely overwrite existing words.
  bool overlaps(WordEntry entry) {
    final location = entry.location;
    final word = entry.word;
    final direction = entry.direction;

    final x = location.x;
    final y = location.y;
    final prefix = switch (direction) {
      Direction.across => characterMap[location.copyWith(x: x - 1)],
      Direction.down => characterMap[location.copyWith(y: y - 1)],
    };
    final suffix = switch (direction) {
      Direction.across => characterMap[location.copyWith(x: x + word.length)],
      Direction.down => characterMap[location.copyWith(y: y + word.length)],
    };

    return suffix != null || prefix != null || !overrides(entry);
  }

  /// Whether the new [entry] overrides an existing word.
  ///
  /// For example:
  ///
  /// Considering this board:
  /// ```
  ///    -2 -1  0  1  2
  /// -2  -  -  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  /// Adding "ALBUS" at (0, -2) would override "BUS" completely.
  ///
  /// See also:
  ///
  /// * [overlaps] for a more general check.
  bool overrides(WordEntry entry) {
    final location = entry.location;
    final word = entry.word;
    final direction = entry.direction;

    final innerWordEntries = <WordEntry>{};
    for (var i = 0; i < word.length; i++) {
      final newLocation = direction == Direction.across
          ? location.copyWith(x: location.x + i)
          : location.copyWith(y: location.y + i);
      final characterData = characterMap[newLocation];
      if (characterData != null) {
        innerWordEntries.addAll(characterData.wordEntry);
      }
    }

    for (final innerWordEntry in innerWordEntries) {
      final start = innerWordEntry.location;
      final end = switch (innerWordEntry.direction) {
        Direction.across =>
          start.copyWith(x: start.x + innerWordEntry.word.length),
        Direction.down =>
          start.copyWith(y: start.y + innerWordEntry.word.length),
      };
      if (start.x <= location.x && end.x >= location.x) {
        return true;
      }
    }

    return true;
  }

  /// The words at a given [location].
  ///
  /// For example:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  /// The words at location (0, -2) are "ALBUS" and "BEHAN".
  Set<WordEntry> wordsAt(Location location) {
    return characterMap[location]?.wordEntry ?? {};
  }

  /// The constraints for a given [candidate].
  ///
  /// For example:
  ///
  /// Consider this board:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  O  W
  /// ```
  ///
  /// Adding a word down at (2, -2) would have a single
  /// [ConstrainedWordCandidate], with two constraints one at position 0 for the
  /// character 'S' and another at position 4 for the character 'W' with a
  /// maximum length of [largestWordLength].
  ///
  /// If we consider this other board:
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  N  A  N  -
  ///  2  -  -  N  O  W
  /// ```
  ///
  /// Adding a word down at (2, -2) would have a single
  /// [ConstrainedWordCandidate], with one constraint one at position 0 for the
  /// character 'S' with a maximum length of 3. Since a longer word would
  /// [overlaps] with the word "NAN".
  ///
  /// Adding a word down at (-1, -2) would have more than one
  /// [ConstrainedWordCandidate], those cases will return `null`. This behavior
  /// is something we would like to consider in the future.
  ///
  /// It assumes that the [candidate] is valid, meaning that it doesn't
  /// [overlaps] and it [isConnected].
  ConstrainedWordCandidate? constraints(WordCandidate candidate) {
    for (var i = 0; i < largestWordLength; i++) {
      switch (candidate.direction) {
        case Direction.across:
          final x = candidate.location.x + i;
          final y = candidate.location.y;

        // positions.addAll(
        //   [
        //     Location(x: x, y: y - 1),
        //     Location(x: x, y: y + 1),
        //     if (isFirstCharacter) Location(x: x - 1, y: y),
        //     if (isLastCharacter) Location(x: x + 1, y: y),
        //   ],
        // );
        case Direction.down:
          final x = candidate.location.x;
          final y = candidate.location.y + i;

          final leftLocation = Location(x: x - 1, y: y);

          final rightValue = characterMap[leftLocation];

          positions.addAll(
            [
              Location(x: x - 1, y: y),
              Location(x: x + 1, y: y),
              if (isFirstCharacter) Location(x: x, y: y - 1),
              if (isLastCharacter) Location(x: x, y: y + 1),
            ],
          );
      }
    }
  }
}
