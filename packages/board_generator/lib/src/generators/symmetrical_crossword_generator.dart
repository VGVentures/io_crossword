// coverage:ignore-file

import 'package:board_generator/board_generator.dart';

/// {@template symmetrical_crossword_generator}
/// A simple crossword generator that populates a crossword with an
/// horizontal line of symmetry.
/// {@endtemplate}
class SymmetricalCrosswordGenerator extends CrosswordGenerator {
  /// {@macro symmetrical_crossword_generator}
  SymmetricalCrosswordGenerator({
    required super.pool,
    required super.crossword,
  });

  static const _symmetry = HorizontalLineOfSymmetry();

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
      start: Location(
        x: bounds.topLeft.x,
        y: HorizontalLineOfSymmetry.yIntercept - (word.length ~/ 2),
      ),
      direction: constraints.direction,
    );

    crossword.add(entry);

    pool.remove(entry.word);
    final expansion = entry.end
        .to(entry.start)
        .map(
          (location) =>
              WordCandidate(start: location, direction: Direction.across),
        )
        .toList()
        .reversed
        .toSet();
    candidates.addAll(expansion);
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

    void invalidate(int length) {
      validLengths.remove(length);
      constraints.invalidLengths.add(length);
    }

    if (candidate.direction == Direction.down) {
      final symmetricalLength = (candidate.start.y * 2) - 1;

      if (symmetricalLength.isOdd) {
        final symmetryCrossingCandidate = WordCandidate(
          start: candidate.start.shift(y: -symmetricalLength),
          direction: constraints.direction,
        );
        final symmetricalConstraints =
            crossword.constraints(symmetryCrossingCandidate);

        if (symmetricalConstraints != null) {
          final word = pool.firstMatchByWordLength(
            symmetricalConstraints,
            symmetricalLength,
          );
          if (word != null) {
            return {
              WordEntry(
                word: word,
                start: symmetryCrossingCandidate.start,
                direction: symmetryCrossingCandidate.direction,
              ),
            };
          }
        }
      }

      for (var length = pool.shortestWordLength;
          length <= pool.longestWordLength;
          length++) {
        if (length >= symmetricalLength) {
          invalidate(length);
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

      final symmetricalWordCandidate = WordCandidate(
        start: _symmetry.mirror(wordEntry),
        direction: constraints.direction,
      );

      final symmetricalConstraints =
          crossword.constraints(symmetricalWordCandidate);
      if (symmetricalConstraints == null) {
        invalidate(word.length);
        continue;
      }

      final symmetricalWord = pool.firstMatchByWordLength(
        symmetricalConstraints,
        word.length,
        word,
      );
      if (symmetricalWord == null) {
        invalidate(word.length);
        continue;
      }

      final symmetricalWordEntry = WordEntry(
        word: symmetricalWord,
        start: symmetricalWordCandidate.start,
        direction: constraints.direction,
      );

      if (crossword.overlaps(wordEntry) ||
          crossword.overlaps(symmetricalWordEntry)) {
        invalidate(word.length);
        continue;
      }

      return {wordEntry, symmetricalWordEntry};
    }

    return null;
  }

  @override
  Set<WordCandidate> expand(WordEntry entry) {
    final span = entry.start.to(entry.end)
      ..removeWhere((location) => _symmetry.isAbove(location.y));

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
      ..removeWhere((location) => _symmetry.isAbove(location.y));

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
