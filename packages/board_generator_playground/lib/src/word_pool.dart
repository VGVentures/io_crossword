import 'package:board_generator_playground/src/models/word_candidate.dart';
import 'package:board_generator_playground/src/sort_words.dart';
import 'package:meta/meta.dart';

/// {@template word_pool}
/// A pool of words that can be used to create a Crossword.
/// {@endtemplate}
class WordPool {
  /// {@macro word_pool}
  WordPool({
    required Iterable<String> words,
    required int maxLengthWord,
    required int minLengthWord,
  }) {
    sortedWords = sortWords(words);
    _maxLengthWord = maxLengthWord;
    _minLengthWord = minLengthWord;
  }

  /// The list of words sorted with [sortWords]
  @visibleForTesting
  late final SortedWords sortedWords;

  late final int _maxLengthWord;
  late final int _minLengthWord;

  /// Retrieves the first word that matches the given
  /// [constrainedWordCandidate].
  ///
  /// If no word within the pool matches the constraints, `null` is returned.
  ///
  /// The first longest word that respects the [constrainedWordCandidate] is
  /// returned.
  String? firstMatch(ConstrainedWordCandidate constrainedWordCandidate) {
    final constraints = constrainedWordCandidate.constraints;
    final invalidLengths = constrainedWordCandidate.invalidLengths;

    for (var i = _maxLengthWord; i >= _minLengthWord; i--) {
      if (invalidLengths.contains(i)) continue;

      // We remove the first constrain because we previously search
      // with the first constrains and we also need to remove constrains bigger
      // than the characters available.
      final updatedConstrains = <int, String>{
        ...constraints,
      }..removeWhere((key, value) => key > i);

      final firstConstrains = updatedConstrains.entries.first;

      final words =
          sortedWords[i]?[firstConstrains.key]?[firstConstrains.value] ?? {};

      if (words.isEmpty) continue;

      if (constraints.length == 1) {
        return words.first;
      }

      updatedConstrains.remove(firstConstrains.key);

      final word = words.firstWhere(
        (word) {
          return !updatedConstrains.entries.any(
            (constrain) => !word.startsWith(constrain.value, constrain.key),
          );
        },
        orElse: () => '',
      );

      if (word.isNotEmpty) {
        return word;
      }
    }

    return null;
  }

  /// Removes the given word from the pool.
  ///
  /// If the length of the word, the position of the character or
  /// the initial of the character is not founded will throw exception.
  void remove(String word) {
    final wordLengthPosition = sortedWords[word.length]!;

    for (var i = 0; i < word.length; i++) {
      final character = word[i].toLowerCase();
      wordLengthPosition[i]![character]!.remove(word);
    }
  }

  /// Removes the given list of words from the pool using [remove].
  void removeAll(Iterable<String> words) {
    for (final word in words) {
      remove(word);
    }
  }
}
