// coverage:ignore-file

import 'package:board_generator/board_generator.dart';

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
  void add(WordEntry entry) {
    super.add(entry);

    if (crossword.words.length % 1000 == 0) {
      // ignore: avoid_print
      print(crossword.words.length);
    }
  }

  @override
  void seed() {
    final bounds = crossword.bounds!;

    const constraints = ConstrainedWordCandidate(
      invalidLengths: {},
      start: Location.zero,
      direction: Direction.across,
      constraints: {0: 'e'},
    );
    final word = pool.firstMatch(constraints)!;
    final entry = WordEntry(
      word: word,
      start: Location(
        x: bounds.topLeft.x,
        y: bounds.topLeft.y,
      ),
      direction: constraints.direction,
    );
    add(entry);
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
    expansion.removeWhere(crossword.crossesAt);

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

    return candidates;
  }
}
