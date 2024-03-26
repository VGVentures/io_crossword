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
  WordCandidate? get nextCandidate {
    if (crossword.words.length > 150000) return null;
    return super.nextCandidate;
  }

  @override
  void seed() {
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
      start: Location(x: 0, y: 0 - (word.length ~/ 2)),
      direction: constraints.direction,
    );
    add(entry);

    final firstWordLocation = const Location(x: 0, y: 1).to(entry.end);

    final newDirection =
        entry.direction == Direction.down ? Direction.across : Direction.down;

    candidates.addAll(
      firstWordLocation.map(
        (location) => WordCandidate(
          start: location,
          direction: newDirection,
        ),
      ),
    );
  }

  @override
  Set<WordEntry>? resolve(WordCandidate candidate) {
    final constraints = crossword.constraints(candidate);
    if (constraints == null) return null;

    // TODO(Ayad): constrainedWordCandidate.invalidLengths will be changed to
    // valid lengths so this can be removed once that is ready.
    // Once changes we need to update constraints.invalidLengths.add(length);
    // to remove.
    final validLengths = <int>[];
    for (var i = pool.shortestWordLength; i < pool.longestWordLength; i++) {
      if (!constraints.invalidLengths.contains(i)) {
        validLengths.add(i);
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
        // TODO(Ayad): Investigate, this should not be reached.
        //  Investigate constraints and selection.

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
    if (entry.start.y < 0) return {};

    final span = entry.start.to(entry.end);
    final newDirection =
        entry.direction == Direction.down ? Direction.across : Direction.down;
    return {
      for (final location in span)
        WordCandidate(
          start: location,
          direction: newDirection,
        ),
    };
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
