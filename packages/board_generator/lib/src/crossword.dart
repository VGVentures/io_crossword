import 'package:board_generator/board_generator.dart';

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
    required this.largestWordLength,
    required this.shortestWordLength,
    this.bounds,
  });

  /// {@macro character_map}
  final CharacterMap characterMap = {};

  /// The words on the board.
  final Set<WordEntry> words = {};

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

    words.add(entry);

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
  /// ```none
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
  /// ```none
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
  /// ```none
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  S  -  H  -  -
  ///  1  U  -  A  -  -
  ///  2  N  -  N  -  -
  /// ```
  bool isConnected(FixedLengthWordCandidate entry) {
    final location = entry.start;
    final direction = entry.direction;

    for (var i = 0; i < entry.length; i++) {
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
  /// ```none
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
  /// ```none
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
  /// ```none
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
  /// ```none
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
  /// ```none
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
  /// ```none
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
  bool overlaps(FixedLengthWordCandidate entry) {
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

    for (var i = 0; i < entry.length; i++) {
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
  /// ```none
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
  /// ```none
  ///    -2 -1  0  1  2
  /// -2  W  E  B  S  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  bool overrides(FixedLengthWordCandidate entry) {
    final spans = entry.start.to(entry.end);

    if (entry is WordEntry) {
      for (var i = 0; i < spans.length; i++) {
        final location = spans.elementAt(i);
        final characterData = characterMap[location];
        if (characterData != null && characterData.character != entry.word[i]) {
          return true;
        }
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
  /// ```none
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

  /// Whether a [location] crosses with another word.
  ///
  /// For example, consider the following board:
  ///
  /// ```none
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  ///
  /// The location (0, -2) crosses with the word "ALBUS" and "BEHAN". However,
  /// the location (0, 0) does not cross with any word.
  bool crossesAt(Location location) {
    final characterData = characterMap[location];
    if (characterData == null) return false;

    return characterData.wordEntry.length > 1;
  }

  /// The constraints for a given [candidate].
  ///
  /// For example, consider the following board:
  ///
  /// ```none
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
  /// maximum length of [largestWordLength] but an invalid length of 4, since it
  /// would otherwise suffix "W".
  ///
  /// Adding a word down at (-1, -2) would have more than one
  /// [ConstrainedWordCandidate]. In other words, more than a single word would
  /// have to be placed at the same time to satisfy the constraints. In this
  /// those cases we return `null`. Such scenarios are yet not properly
  /// considered, it is something we would like to contemplate in the future and
  /// improve to achieve denser boards.
  ///
  /// If the constraints cannot be satisfied (for example, when all the lengths
  /// are invalid) we return `null`.
  ConstrainedWordCandidate? constraints(WordCandidate candidate) {
    final validLengths = _lengthConstraints(candidate);

    // If there are no valid lengths, the constraint is unsatisfiable.
    if (validLengths.isEmpty) return null;

    final longestValidLength = validLengths.reduce((a, b) => a > b ? a : b);
    final characterConstraints = _characterConstraints(
      candidate.fixTo(longestValidLength),
    );

    final invalidLengths = {
      for (var length = shortestWordLength;
          length <= largestWordLength;
          length++)
        if (!validLengths.contains(length)) length,
    };

    return ConstrainedWordCandidate(
      invalidLengths: invalidLengths,
      start: candidate.start,
      direction: candidate.direction,
      constraints: characterConstraints,
    );
  }

  /// The valid lengths for a given [candidate].
  Set<int> _lengthConstraints(WordCandidate candidate) {
    final candidates = {
      for (var length = shortestWordLength;
          length <= largestWordLength;
          length++)
        candidate.fixTo(length),
    }
      ..removeWhere((candidate) => !isConnected(candidate))
      ..removeWhere(overlaps)
      ..removeWhere((candidate) {
        // Invalidate those lengths that would reach another word going in the
        // same direction in its surroundings. Such cases would require more
        // than one word to be placed at the same time.
        final surroundings = candidate.surroundings();
        final words = surroundings.map(wordsAt).expand((e) => e);
        return words.any((word) => word.direction == candidate.direction);
      });

    final bounds = this.bounds;
    if (bounds != null) {
      candidates.removeWhere((candidate) {
        final span = candidate.start.to(candidate.end);
        return span.any((location) => !bounds.contains(location));
      });
    }

    return candidates.map((e) => e.length).toSet();
  }

  Map<int, String> _characterConstraints(FixedLengthWordCandidate candidate) {
    final constraints = <int, String>{};
    for (var length = 0; length < candidate.length; length++) {
      final location = switch (candidate.direction) {
        Direction.across => candidate.start.shift(x: length),
        Direction.down => candidate.start.shift(y: length),
      };
      final characterData = characterMap[location];
      if (characterData != null) {
        constraints[length] = characterData.character;
      }
    }

    return constraints;
  }

  /// A pretty string representation of the board.
  ///
  /// For example, a board with the words "ALBUS" and "BEHAN" would be:
  ///
  /// ```txt
  ///    -2 -1  0  1  2
  /// -2  A  L  B  U  S
  /// -1  -  -  E  -  -
  ///  0  -  -  H  -  -
  ///  1  -  -  A  -  -
  ///  2  -  -  N  -  -
  /// ```
  String toPrettyString() {
    final stringBuffer = StringBuffer();

    final minX =
        characterMap.keys.map((e) => e.x).reduce((a, b) => a < b ? a : b);
    final maxX =
        characterMap.keys.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    final minY =
        characterMap.keys.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY =
        characterMap.keys.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    final minXLength = minX.toString().length;
    final maxXLength = maxX.toString().length;
    final columnWidth = (minXLength > maxXLength ? minXLength : maxXLength) + 1;

    final width = maxX - minX + 1;

    stringBuffer.write(''.padLeft(columnWidth));
    for (var column = minX; column <= maxX; column++) {
      stringBuffer.write(column.toString().padLeft(columnWidth));
    }
    stringBuffer.writeln();

    for (var row = minY; row <= maxY; row++) {
      stringBuffer.write(row.toString().padLeft(columnWidth));
      final characters = List.generate(width, (column) {
        final location = Location(x: column + minX, y: row);
        final character = characterMap[location]?.character ?? '-';
        return character.toUpperCase().padLeft(columnWidth);
      });

      stringBuffer.writeln(characters.join());
    }

    return stringBuffer.toString();
  }
}
