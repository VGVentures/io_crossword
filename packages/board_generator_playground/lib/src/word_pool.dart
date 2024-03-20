import 'package:board_generator_playground/src/models/word_candidate.dart';
import 'package:board_generator_playground/src/sort_words.dart';

/// {@template word_pool}
/// A pool of words that can be used to create a Crossword.
/// {@endtemplate}
class WordPool {
  /// {@macro word_pool}
  WordPool({required Iterable<String> words});

  final SortedWords _sortedWords = SortedWords();

  /// Retrieves the first word that matches the given [constraint].
  ///
  /// If no word within the pool matches the constraints, `null` is returned.
  ///
  /// The first longest word that respects the [constraint] is returned.
  String? firstMatch(ConstrainedWordCandidate constraint) {
    // TODO(Ayad): Implement and test this.
    throw UnimplementedError();
  }

  /// Removes the given word from the pool.
  void remove(String word) {
    // TODO(Ayad): Remove the extension method on [SortedWord] and use the method here.
    throw UnimplementedError();
  }
}
