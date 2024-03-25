import 'package:board_generator_playground/board_generator_playground.dart';

/// {@template crossword_generator}
/// A generator that populates a [Crossword] with words from a [WordPool].
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
  ///
  /// Should only be called once, otherwise you will try populating an
  /// already populated crossword.
  Crossword populate() {
    seed();

    do {
      final candidate = nextCandidate;
      if (candidate == null) break;
      candidates.remove(candidate);
      closed.add(candidate);

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
