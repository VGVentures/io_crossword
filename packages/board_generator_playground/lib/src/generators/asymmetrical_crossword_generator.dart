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

  final Location center = Location.zero;

  @override
  WordCandidate? get nextCandidate {
    if (crossword.words.length > 50000) return null;
    return super.nextCandidate;
  }

  @override
  void add(WordEntry entry) {
    super.add(entry);

    if (crossword.words.length % 1000 == 0) {
      print(crossword.words.length);
    }
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
      start: Location(x: center.x, y: center.y - (word.length ~/ 2)),
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
      ..removeWhere(closed.contains);

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
}

void main() {
  final word = WordEntry(
      word: 'alejandro', start: Location.zero, direction: Direction.across);
  final crossword = Crossword()..add(word);

  Set<WordCandidate> expand(WordEntry entry) {
    final span = entry.start.to(entry.end);

    final expansion = <Location>{};
    for (var i = 0; i < 3; i++) {
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

  final candidates = expand(word);

  for (final candidate in candidates) {
    final words = crossword.wordsAt(candidate.start);
    if (words.isNotEmpty) continue;

    crossword.add(
      WordEntry(
        word: '*',
        start: candidate.start,
        direction: Direction.across,
      ),
    );
  }

  print(crossword.toPrettyString());
}
