// coverage:ignore-file

import 'package:board_generator_playground/board_generator_playground.dart';

/// {@template symmetrical_crossword_generator}
/// A simple crossword generator that populates a crossword without
/// any line of symmetry.
/// {@endtemplate}
class SymmetricalCrosswordGenerator extends CrosswordGenerator {
  /// {@macro symmetrical_crossword_generator}
  SymmetricalCrosswordGenerator({
    required super.pool,
    required super.crossword,
  });

  @override
  void add(WordEntry entry) {
    super.add(entry);

    if (crossword.words.length % 1000 == 0) {
      // ignore: avoid_print
      print('Placed ${crossword.words.length} words');
    }
  }

  @override
  void seed() {
    final bounds = crossword.bounds!;

    final constraints = ConstrainedWordCandidate(
      invalidLengths: {
        for (int i = 2; i <= pool.longestWordLength; i += 2) i,
      },
      start: Location.zero,
      direction: Direction.down,
      constraints: const {0: 'a'},
    );
    final word = pool.firstMatch(constraints)!;
    final entry = WordEntry(
      word: word,
      start: Location(x: bounds.topLeft.x, y: 0 - (word.length ~/ 2)),
      direction: constraints.direction,
    );
    add(entry);
  }

  @override
  Set<WordEntry>? resolve(WordCandidate candidate) {
    final constraints = crossword.constraints(candidate);
    if (constraints == null) return null;

    final validLengths = <int>[];
    for (var i = pool.shortestWordLength; i < pool.longestWordLength; i++) {
      if (!constraints.invalidLengths.contains(i)) {
        validLengths.add(i);
      }
    }

    // Invalidate those lengths that cross over the line of symmetry.
    if (candidate.direction == Direction.down) {
      for (var i = 0; i <= pool.longestWordLength; i++) {
        final verticalPosition = candidate.start.y - i;
        if (verticalPosition < 0) {
          validLengths.remove(i);
          constraints.invalidLengths.add(i);
        }
      }
    }

    while (validLengths.isNotEmpty) {
      final word = pool.firstMatch(constraints);
      if (word == null) return null;

      final wordEntry = WordEntry(
        word: word,
        start: candidate.start,
        direction: candidate.direction,
      );

      final symmetricalLocation = _horizontallySymmetricalLocation(wordEntry);

      final symmetricalWordCandidate = WordCandidate(
        start: symmetricalLocation,
        direction: constraints.direction,
      );

      final symmetricalConstrainedWordCandidate =
          crossword.constraints(symmetricalWordCandidate);
      if (symmetricalConstrainedWordCandidate == null) {
        final length = word.length;
        constraints.invalidLengths.add(length);
        validLengths.removeWhere((value) => value == length);
        continue;
      }

      final symmetricalNewWord = pool.firstMatchByWordLength(
        symmetricalConstrainedWordCandidate,
        word.length,
        word,
      );
      if (symmetricalNewWord == null) {
        constraints.invalidLengths.add(word.length);
        validLengths.removeWhere((value) => value == word.length);
        continue;
      }

      final symmetricalNewWordEntry = WordEntry(
        word: symmetricalNewWord,
        start: _horizontallySymmetricalLocation(wordEntry),
        direction: constraints.direction,
      );

      if (crossword.overlaps(wordEntry) ||
          crossword.overlaps(symmetricalNewWordEntry)) {
        // TODO(Ayad): Investigate, this should not be reached. Investigate constraints and selection.
        constraints.invalidLengths.add(word.length);
        validLengths.removeWhere((value) => value == word.length);
        continue;
      }

      return {
        wordEntry,
        symmetricalNewWordEntry,
      };
    }

    return null;
  }

  @override
  Set<WordCandidate> expand(WordEntry entry) {
    final span = entry.start.to(entry.end)
      ..removeWhere((location) => location.y < 0);

    final expansion = <Location>{};
    for (var i = 0; i < pool.longestWordLength; i++) {
      for (final location in span) {
        entry.direction == Direction.across
            ? expansion.add(location.shift(y: -i))
            : expansion.add(location.shift(x: -i));
        entry.direction == Direction.across
            ? expansion.add(location.shift(y: i))
            : expansion.add(location.shift(x: i));
      }
    }
    expansion
      ..removeWhere(crossword.crossesAt)
      ..removeWhere((location) => location.y < 0);

    final bounds = crossword.bounds;
    if (bounds != null) {
      expansion.removeWhere((location) => !bounds.contains(location));
    }

    final candidates = <WordCandidate>{};
    for (final location in expansion) {
      final words = crossword.wordsAt(location);
      if (!words.any((word) => word.direction == Direction.across)) {
        candidates
            .add(WordCandidate(start: location, direction: Direction.across));
      }
      if (!words.any((word) => word.direction == Direction.down)) {
        candidates
            .add(WordCandidate(start: location, direction: Direction.down));
      }
    }
    candidates.removeWhere(closed.contains);

    return candidates;
  }

  Location _horizontallySymmetricalLocation(WordEntry wordEntry) {
    switch (wordEntry.direction) {
      case Direction.across:
        return wordEntry.start.copyWith(y: wordEntry.end.y * -1);
      case Direction.down:
        return wordEntry.end.copyWith(y: wordEntry.end.y * -1);
    }
  }
}
