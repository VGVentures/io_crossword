import 'dart:io';

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:board_generator_playground/src/word_pool.dart';
import 'package:csv/csv.dart';

/// {@template crossword_generator}
///
/// {@endtemplate}
abstract class CrosswordGenerator {
  /// {@macro crossword_generator}
  CrosswordGenerator({
    required this.pool,
    required this.crossword,
  });

  /// The word pool to draw from.
  final WordPool pool;

  /// The crossword to populate.
  final Crossword crossword;

  /// The candidates yet to be expanded.
  final Set<WordCandidate> candidates = {};

  /// The candidates that have been expanded.
  final Set<WordCandidate> closed = {};

  /// Populates the crossword with words.
  Crossword populate() {
    seed();

    do {
      final candidate = nextCandidate;
      if (candidate == null) break;

      final entries = resolve(candidate);
      if (entries == null) continue;

      for (final entry in entries) {
        add(entry);
      }
    } while (nextCandidate != null);

    return crossword;
  }

  /// Seeds the generator with initial candidates.
  void seed();

  /// The next candidate to expand.
  ///
  /// Returns `null` if there are no candidates left.
  WordCandidate? get nextCandidate {
    if (candidates.isEmpty) return null;
    final candidate = candidates.first;
    return candidate;
  }

  /// Resolves the candidate to a different [WordEntry]s to be
  /// placed on the board.
  ///
  /// If the candidate cannot be resolved, `null` is returned.
  Set<WordEntry>? resolve(WordCandidate candidate);

  /// Adds the entry to the crossword and expands it.
  void add(WordEntry entry) {
    crossword.add(entry);
    pool.remove(entry.word);
    final expansion = expand(entry)..removeWhere(closed.contains);
    candidates.addAll(expansion);
  }

  /// Expands the candidate.
  Set<WordCandidate> expand(WordEntry entry);
}

class _SimpleSquaredCrosswordGenerator extends CrosswordGenerator {
  _SimpleSquaredCrosswordGenerator({
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
    final expansion = <WordCandidate>{};
    final topLeft = entry.direction == Direction.across
        ? Location(
            x: entry.start.x - pool.longestWordLength,
            y: entry.start.y,
          )
        : Location(
            x: entry.start.x,
            y: entry.start.y - pool.longestWordLength,
          );
    final bottomRight = entry.direction == Direction.across
        ? Location(
            x: entry.end.x + pool.longestWordLength,
            y: entry.end.y,
          )
        : Location(
            x: entry.end.x,
            y: entry.end.y + pool.longestWordLength,
          );
    final radius = topLeft.to(bottomRight);

    for (final location in radius) {
      final words = crossword.wordsAt(location);
      if (!words.any((word) => word.direction == Direction.across)) {
        expansion.add(
          WordCandidate(
            start: location,
            direction: Direction.across,
          ),
        );
      }
      if (!words.any((word) => word.direction == Direction.down)) {
        expansion.add(
          WordCandidate(
            start: location,
            direction: Direction.down,
          ),
        );
      }
    }

    return expansion;
  }
}

void main({void Function(String) log = print}) {
  final fileString = File('words.csv').readAsStringSync();
  final lines = const CsvToListConverter(eol: '\n').convert(fileString)
    ..removeAt(0);

  final pool = <String>{
    for (final line in lines) (line[0] as String).toLowerCase(),
  };
  final wordPool = WordPool(words: pool);

  final generator = _SimpleSquaredCrosswordGenerator(
    pool: wordPool,
    crossword: Crossword(bounds: Bounds.square(size: 100)),
  );

  final crossword = generator.populate();
  File('crossword.txt').writeAsStringSync(crossword.toPrettyString());
}
