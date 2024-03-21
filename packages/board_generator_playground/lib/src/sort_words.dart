/// Sorted words is organized with this data structure to improve the finding
/// of words to be placed in the board.
///
/// See also:
///
/// * [sortWords] function that sorts words into a [SortedWords].
typedef SortedWords = Map<int, Map<int, Map<String, Set<String>>>>;

/// Organizes the words into a data structure that can be used to find words
/// that can be placed in the crossword.
///
/// For example:
///
/// Given the list of words 'Aunt', 'Addy', 'Adds' and 'Away'. Sorting them
/// using the [sortWords] function will sort them as:
///
/// ```dart
/// {
///    4: {
///     0: {
///       'a': {'Adds', 'Addy', 'Aunt', 'Away'},
///     },
///     1: {
///       'u': {'Aunt'},
///       'd': {'Adds', 'Addy'},
///       'w': {'Away'},
///     },
///     2: {
///       'n': {'Aunt'},
///       'd': {'Adds', 'Addy'},
///       'a': {'Away'},
///     },
///     3: {
///       't': {'Aunt'},
///       'y': {'Addy', 'Away'},
///       's': {'Adds'},
///     },
///   },
/// }
/// ```
///
/// In essence, it maps the number of characters in the word to a map that maps
/// the location of the character in the word.
SortedWords sortWords(
  Iterable<String> wordList,
) {
  final sortedWords = SortedWords();

  for (final word in wordList) {
    if (!sortedWords.containsKey(word.length)) {
      sortedWords[word.length] = <int, Map<String, Set<String>>>{
        for (var i = 0; i < word.length; i++) i: <String, Set<String>>{},
      };
    }

    for (var i = 0; i < word.length; i++) {
      final character = word[i].toLowerCase();
      final mapCharacterPosition = sortedWords[word.length]![i]!;

      if (!mapCharacterPosition.containsKey(character)) {
        mapCharacterPosition[character] = <String>{};
      }

      mapCharacterPosition[character]!.add(word);
    }
  }

  return sortedWords;
}
