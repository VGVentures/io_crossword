// coverage:ignore-file

import 'package:board_generator_playground/board_generator_playground.dart';

/// {@template asymmetrical_crossword_generator}
/// A simple crossword generator that populates a crossword without
/// any line of symmetry.
/// {@endtemplate}
class AsymmetricalCrosswordGenerator extends CrosswordGenerator {
  /// {@macro asymmetrical_crossword_generator}
  AsymmetricalCrosswordGenerator({
    required super.pool,
    required super.crossword,
  });

  @override
  WordCandidate? get nextCandidate {
    if (crossword.words.length > 1000) return null;
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
    candidates.addAll(expand(entry));
  }

  @override
  Set<WordEntry>? resolve(WordCandidate candidate) {
    final constraints = crossword.constraints(candidate);
    if (constraints == null) return null;

    final word = pool.firstMatch(constraints);
    if (word == null) return null;

    return {
      WordEntry(
        word: word,
        start: candidate.start,
        direction: candidate.direction,
      ),
    };
  }

  @override
  Set<WordCandidate> expand(WordEntry entry) {
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
}
