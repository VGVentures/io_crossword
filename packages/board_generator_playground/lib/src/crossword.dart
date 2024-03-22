import 'package:board_generator_playground/src/models/models.dart';

/// {@template character_map}
/// Maps a [Location] to a [CharacterData].
/// {@endtemplate}
typedef CharacterMap = Map<Location, CharacterData>;

/// {@template crossword}
/// The board for the crossword puzzle.
/// {@endtemplate}
class Crossword {
  /// {@macro crossword}
  Crossword({
    this.bounds,
    this.largestWordLength = 18,
    this.shortestWordLength = 3,
  });

  /// {@macro character_map}
  final CharacterMap characterMap = {};

  /// The largest word length that can be added to the board.
  final int largestWordLength;

  /// The shortest word length that can be added to the board.
  final int shortestWordLength;

  /// The bounds of the board.
  ///
  /// If `null`, the board has no bounds. Meaning it can grow indefinitely in
  /// horizontally and vertically.
  final Bounds? bounds;

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
  /// Adding the word "USA" at (1, -2) would have five connections:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  S  -
  ///  0  -  -  H  A  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// If we label the connections with a "*" we would have:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  A  L  *  *  *
  /// -1  -  -  *  S  -
  ///  0  -  -  *  A  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  Set<Location> connections(WordEntry entry) {
    final area = {
      ...entry.start.to(entry.end),
      ...entry.surroundings(),
    };

    return area.where((location) {
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
    if (overrides(entry)) return true;

    final span = entry.start.to(entry.end);
    final spannedWords = span.map(wordsAt).expand((e) => e);
    if (spannedWords.any((e) => e.direction == entry.direction)) {
      return true;
    }

    if (characterMap[entry.prefix] != null ||
        characterMap[entry.suffix] != null) {
      return true;
    }

    for (var i = 0; i < entry.word.length; i++) {
      final sideA = entry.direction == Direction.across
          ? entry.start.shift(x: i, y: -1)
          : entry.start.shift(x: -1, y: i);
      final sideB = entry.direction == Direction.across
          ? entry.start.shift(x: i, y: 1)
          : entry.start.shift(x: 1, y: i);

      final sideWords = wordsAt(sideA).union(wordsAt(sideB))
        ..removeAll(spannedWords);
      if (sideWords.any((e) => e.direction != entry.direction)) {
        return true;
      }
    }

    return false;
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
  /// Partial overrides are also considered, for example, adding "WEBS"
  /// at (-2, -2) would override "BUS" partially.
  ///
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -2  W  E  B  S  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  bool overrides(WordEntry entry) {
    final spans = entry.start.to(entry.end);

    for (var i = 0; i < spans.length; i++) {
      final location = spans.elementAt(i);
      final characterData = characterMap[location];
      if (characterData != null && characterData.character != entry.word[i]) {
        return true;
      }
    }

    final innerWords = spans
        .map(wordsAt)
        .expand((e) => e)
        .where((word) => word.direction == entry.direction);

    return innerWords.any((e) {
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
  /// [ConstrainedWordCandidate], those cases will return `null`. Such
  /// scenarios are yet not properly considered, it is something we would like
  /// to contemplate in the future and improve to achieve denser boards.
  ConstrainedWordCandidate? constraints(WordCandidate candidate) {
    final invalidLengths = <int>{};
    var maximumLength = 1;

    for (var i = 1; i <= largestWordLength; i++) {
      final end = switch (candidate.direction) {
        Direction.across => candidate.location.shift(x: i),
        Direction.down => candidate.location.shift(y: i),
      };
      if (bounds != null && !bounds!.contains(end)) {
        for (var k = i + 1; k <= largestWordLength; k++) {
          invalidLengths.add(k);
        }
        break;
      }

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
        ...wordsAt(end),
      };

      final hasMatchingDirection =
          words.any((word) => word.direction == candidate.direction);
      final hasWordOfMinimumLength = i < shortestWordLength;
      if (hasMatchingDirection && hasWordOfMinimumLength) {
        return null;
      } else if (hasMatchingDirection) {
        for (var k = i; k <= largestWordLength; k++) {
          invalidLengths.add(k);
        }
        break;
      }

      if (words.any(overlaps)) {
        final location = switch (candidate.direction) {
          Direction.across => candidate.location.shift(x: i),
          Direction.down => candidate.location.shift(y: i),
        };

        if (characterMap[location] == null) {
          for (var k = i; k <= largestWordLength; k++) {
            invalidLengths.add(k);
          }
          break;
        }

        invalidLengths.add(i);
        continue;
      }

      if (i > maximumLength) {
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

  /// A pretty string representation of the board.
  ///
  /// For example, a board with the words "ALBUS" and "BEHAN" would be:
  ///
  /// ```txt
  /// ALBUS
  /// --E--
  /// --H--
  /// --A--
  /// --N--
  /// ```
  String toPrettyString({
    Location? topLeft,
    Location? bottomRight,
  }) {
    final stringBuffer = StringBuffer();

    final minX = topLeft != null
        ? topLeft.x
        : characterMap.keys.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final maxX = bottomRight != null
        ? bottomRight.x
        : characterMap.keys.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    final minY = topLeft != null
        ? topLeft.y
        : characterMap.keys.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = bottomRight != null
        ? bottomRight.y
        : characterMap.keys.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    final width = maxX - minX + 1;

    for (var row = minY; row <= maxY; row++) {
      final characters = List.generate(width, (column) {
        final location = Location(x: column + minX, y: row);
        final character = characterMap[location]?.character ?? '-';
        return character.toUpperCase();
      });

      stringBuffer.writeln(characters.join());
    }

    return stringBuffer.toString();
  }
}
