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

  final Set<WordCandidate> _area = {};

  final Set<Location> _area2 = {};

  @override
  WordCandidate? get nextCandidate {
    if (crossword.words.length > 10000) return null;

    if (candidates.isEmpty && _area.isNotEmpty) {
      return null;

      final candidates = {
        for (final location in _area2)
          WordCandidate(start: location, direction: Direction.across),
        for (final location in _area2)
          WordCandidate(start: location, direction: Direction.down),
      }..removeWhere(closed.contains);
      this.candidates.addAll(candidates);
    }

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

  Set<WordCandidate> area(WordEntry entry) {
    final span = entry.start.to(entry.end);
    final topLeft = entry.direction == Direction.across
        ? Location(
            x: entry.start.x,
            y: entry.start.y - pool.longestWordLength,
          )
        : Location(
            x: entry.start.x - pool.longestWordLength,
            y: entry.start.y,
          );
    final bottomRight = entry.direction == Direction.across
        ? Location(
            x: entry.end.x,
            y: entry.end.y + pool.longestWordLength,
          )
        : Location(
            x: entry.end.x + pool.longestWordLength,
            y: entry.end.y,
          );
    final area = topLeft.to(bottomRight)
      ..removeWhere(span.contains)
      ..removeWhere(crossword.crossesAt);

    final bounds = crossword.bounds;
    if (bounds != null) {
      area.removeWhere((location) => !bounds.contains(location));
    }

    final candidates = <WordCandidate>{};
    for (final location in area) {
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

  @override
  Set<WordCandidate> expand(WordEntry entry) {
    final span = entry.start.to(entry.end);
    final newDirection =
        entry.direction == Direction.down ? Direction.across : Direction.down;

    _area.addAll(area(entry));

    return {
      for (final location in span)
        WordCandidate(
          start: location,
          direction: newDirection,
        ),
    };
  }
}
