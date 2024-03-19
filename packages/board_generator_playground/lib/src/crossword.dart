import 'package:board_generator_playground/src/models/models.dart';

/// {@template character_map}
/// Maps a [Location] to a [CharacterData].
/// {@endtemplate}
typedef CharacterMap = Map<Location, CharacterData>;

/// The board for the crossword puzzle.
class Crossword {
  /// {@macro character_map}
  final CharacterMap characterMap = {};

  /// The largest word length that can be added to the board.
  static const largestWordLength = 18;

  /// The shortest word length that can be added to the board.
  static const shortestWordLength = 3;

  /// The origin of the coordinate system.
  ///
  /// The origin (0, 0) is the middle letter of the first word added to the
  /// board. The first word should have an odd number of letters.
  static const origin = Location.zero;

  /// Adds a word to the board.
  void add(WordEntry entry) {
    final location = entry.start;
    final word = entry.word;
    final direction = entry.direction;

    for (var i = 0; i < word.length; i++) {
      final character = word[i];
      final newLocation = direction == Direction.across
          ? location.shift(x: i)
          : location.shift(y: i);

      final data = (characterMap[newLocation]?..wordEntry.add(entry)) ??
          CharacterData(character: character, wordEntry: {entry});
      characterMap[newLocation] = data;
    }
  }

  /// Determines if a new [entry] will be connected to the existing board.
  ///
  /// For example, consider the following board:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// Adding the word "SUN" at (2, -2) would be connected:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  U
  ///  0  -  -  H  -  N
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// However, adding the word "SUN" at (-2, 0) would not be connected:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  S  -  H  -  -
  ///  1  U  -  A  -  -
  ///  2  N  -  N  -  -
  /// ```
  bool isConnected(WordEntry entry) {
    final location = entry.start;
    final word = entry.word;
    final direction = entry.direction;

    for (var i = 0; i < word.length; i++) {
      final newLocation = direction == Direction.across
          ? location.shift(x: i)
          : location.shift(y: i);

      if (characterMap[newLocation] != null) {
        return true;
      }
    }

    return false;
  }

  /// Determines all the connections for a new [entry].
  ///
  /// For example, considering the following board:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// Adding the word "USA" at (1, -2) would have four connections:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  S  -
  ///  0  -  -  H  A  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  Set<Location> connections(WordEntry entry) {
    return entry.surroundings().where((location) {
      return characterMap[location] != null;
    }).toSet();
  }

  /// Whether the new [entry] overlaps an existing word.
  ///
  /// Overlapping a word means that adding such [entry] would change an
  /// existing word or overwrite it completely.
  ///
  /// For example, consider the following board:
  ///
  /// ```
  ///    -5 -4 -3 -2 -1  0  1  2
  /// -2  -  -  -  A  L  B  U  S
  /// -1  -  -  -  -  -  E  -  -
  ///  0  -  -  -  -  -  H  -  -
  ///  1  -  -  -  -  -  A  -  -
  ///  2  -  -  -  -  -  N  -  -
  /// ```
  ///
  /// Adding the word "USA" at (-5, -2) would overlap with "ALBUS":
  ///
  /// ```
  ///    -5 -4 -3 -2 -1  0  1  2
  /// -2  U  S  A  A  L  B  U  S
  /// -1  -  -  -  -  -  E  -  -
  ///  0  -  -  -  -  -  H  -  -
  ///  1  -  -  -  -  -  A  -  -
  ///  2  -  -  -  -  -  N  -  -
  /// ```
  ///
  /// However, adding the word "SUN" at (2, -2) would not overlap:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  U
  ///  0  -  -  H  -  N
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// Overlaps are not allowed since they would create invalid words or
  /// completely overwrite existing words.
  bool overlaps(WordEntry entry) {
    final connections = this.connections(entry);
    final connectedWords = connections.map(wordsAt).expand((e) => e);
    final endsAtConnection = connectedWords.any(
      (e) => connections.contains(e.end),
    );

    return endsAtConnection || overrides(entry);
  }

  /// Whether the new [entry] overrides an existing word.
  ///
  /// For example, consider the following board:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  -  -  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// Adding "ALBUS" at (0, -2) would override "BUS" completely.
  ///
  /// See also:
  ///
  /// * [overlaps] for a more general check.
  bool overrides(WordEntry entry) {
    final spans = entry.start.to(entry.end);
    final innerWordEntries = spans
        .map(wordsAt)
        .expand((e) => e)
        .where((word) => word.direction == entry.direction);

    return innerWordEntries.any((e) {
      return spans.contains(e.start) && spans.contains(e.end);
    });
  }

  /// The words at a given [location].
  ///
  /// For example, consider the following board:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// The words at location (0, -2) are "ALBUS" and "BEHAN".
  Set<WordEntry> wordsAt(Location location) {
    return characterMap[location]?.wordEntry ?? {};
  }

  /// The constraints for a given [candidate].
  ///
  /// For example, consider the following board:
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
  ///
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
  /// [ConstrainedWordCandidate], with one constraint at position 0 for the
  /// character 'S' and an invalid length of 4, since it would otherwise overlap
  /// with the word "NAN".
  ///
  /// Adding a word down at (-1, -2) would have more than one
  /// [ConstrainedWordCandidate], those cases will be return `null`. These
  /// scenarios are yet not properly considered, it is something we would like
  /// to contemplate in the future and improve to achieve denser boards.
  ConstrainedWordCandidate? constraints(WordCandidate candidate) {
    final invalidLengths = <int>{};
    var maximumLength = 1;
    for (var i = 1; i < largestWordLength; i++) {
      final words = {
        ...wordsAt(
          switch (candidate.direction) {
            Direction.across => candidate.location.shift(x: i, y: 1),
            Direction.down => candidate.location.shift(x: 1, y: i),
          },
        ),
        ...wordsAt(
          switch (candidate.direction) {
            Direction.across => candidate.location.shift(x: i, y: -1),
            Direction.down => candidate.location.shift(x: -1, y: i),
          },
        ),
      };

      final hasMatchingDirection =
          words.any((word) => word.direction == candidate.direction);
      if (hasMatchingDirection) return null;

      if (words.any(overlaps)) {
        invalidLengths.add(i);
      } else if (i > maximumLength) {
        maximumLength = i;
      }
    }

    final constraints = <int, String>{};
    for (var i = 0; i < maximumLength; i++) {
      final location = switch (candidate.direction) {
        Direction.across => candidate.location.shift(x: i),
        Direction.down => candidate.location.shift(y: i),
      };
      final characterData = characterMap[location];
      if (characterData != null) {
        constraints[i] = characterData.character;
      }
    }

    return ConstrainedWordCandidate(
      invalidLengths: invalidLengths,
      location: candidate.location,
      direction: candidate.direction,
      constraints: constraints,
    );
  }
}
