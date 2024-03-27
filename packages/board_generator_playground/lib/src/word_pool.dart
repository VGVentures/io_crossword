import 'package:board_generator_playground/board_generator_playground.dart';
import 'package:meta/meta.dart';

/// {@template word_pool}
/// A pool of words that can be used to create a Crossword.
/// {@endtemplate}
class WordPool {
  /// {@macro word_pool}
  WordPool({required Iterable<String> words}) {
    sortedWords = sortWords(words);

    final longestWord = words.reduce(
      (value, element) => value.length > element.length ? value : element,
    );
    longestWordLength = longestWord.length;

    final smallestWord = words.reduce(
      (value, element) => value.length < element.length ? value : element,
    );
    shortestWordLength = smallestWord.length;
  }

  /// The list of words sorted with [sortWords]
  @visibleForTesting
  late final SortedWords sortedWords;

  /// The length of the longest word in the pool.
  late final int longestWordLength;

  /// The length of the shortest word in the pool.
  late final int shortestWordLength;

  /// Retrieves the first word that matches the given
  /// [constrainedWordCandidate].
  ///
  /// If no word within the pool matches the constraints, `null` is returned.
  ///
  /// The first longest word that respects the [constrainedWordCandidate] is
  /// returned.
  String? firstMatch(ConstrainedWordCandidate constrainedWordCandidate) {
    for (var i = longestWordLength; i >= shortestWordLength; i--) {
      final word = firstMatchByWordLength(constrainedWordCandidate, i);

      if (word != null) return word;
    }

    return null;
  }

  /// Retrieves the first word that matches the given
  /// [constrainedWordCandidate] with the indicated length [wordLength] and
  /// a word not equal to [ignoreWord].
  ///
  /// If no word within the pool matches the constraints, `null` is returned.
  ///
  /// The first longest word that respects the [constrainedWordCandidate] is
  /// returned.
  String? firstMatchByWordLength(
    ConstrainedWordCandidate constrainedWordCandidate,
    int wordLength, [
    String? ignoreWord,
  ]) {
    if (!constrainedWordCandidate.validLengths.contains(wordLength)) {
      return null;
    }

    final constraints = constrainedWordCandidate.constraints;

    // We need to remove constrains bigger than the characters available.
    final updatedConstrains = <int, String>{
      ...constraints,
    }..removeWhere((key, value) => key > wordLength);

    final firstConstrains = updatedConstrains.entries.first;

    final words = sortedWords[wordLength]?[firstConstrains.key]
            ?[firstConstrains.value] ??
        {};

    if (words.isEmpty) return null;

    if (constraints.length == 1) {
      for (final word in words) {
        if (word != ignoreWord) return word;
      }

      return null;
    }

    // We remove the first constrain because we previously searched
    // with the first constrain
    updatedConstrains.remove(firstConstrains.key);

    for (final word in words) {
      if (!updatedConstrains.entries.any(
        (constrain) => !word.startsWith(constrain.value, constrain.key),
      )) {
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
