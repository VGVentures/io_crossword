// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:board_generator_playground/src/models/models.dart';
import 'package:board_generator_playground/src/word_pool.dart';
import 'package:test/test.dart';

void main() {
  group('WordPool', () {
    group('firstMatch', () {
      test('returns null when cannot find word', () {
        final words = ['add', 'red', 'aunt', 'addy', 'adds', 'away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a', 2: 'y'},
          invalidLengths: {},
        );

        expect(wordPool.firstMatch(constrains), isNull);
      });

      test('with no invalid length and one constrain', () {
        final words = ['add', 'red', 'aunt', 'addy', 'adds', 'away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a'},
          invalidLengths: {},
        );

        expect(wordPool.firstMatch(constrains), equals('aunt'));
      });

      test('with no invalid length and 2 constrains', () {
        final words = ['add', 'red', 'aunt', 'addy', 'adds', 'away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a', 2: 'a'},
          invalidLengths: {},
        );

        expect(wordPool.firstMatch(constrains), equals('away'));
      });

      test('with no invalid length and 3 constrains', () {
        final words = ['aunt', 'addy', 'adds', 'away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a', 1: 'd', 3: 's'},
          invalidLengths: {},
        );

        expect(wordPool.firstMatch(constrains), equals('adds'));
      });

      test('with invalid length and one constrain', () {
        final words = ['add', 'red', 'aunt', 'addy', 'adds', 'away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a'},
          invalidLengths: {4},
        );

        expect(wordPool.firstMatch(constrains), equals('add'));
      });

      test('with invalid length and one constrain', () {
        final words = ['add', 'red', 'aunt', 'addy', 'adds', 'away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a'},
          invalidLengths: {4},
        );

        expect(wordPool.firstMatch(constrains), equals('add'));
      });

      test('with invalid length and 2 constrains', () {
        final words = [
          'add',
          'are',
          'red',
          'aunt',
          'addy',
          'adds',
          'away',
          'good',
          'glad',
          'apple',
          'green',
          'grass',
          'glass',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'g', 2: 'a'},
          invalidLengths: {5},
        );

        expect(wordPool.firstMatch(constrains), equals('glad'));
      });

      test('with invalid length and 2 constrains', () {
        final words = [
          'add',
          'are',
          'red',
          'aunt',
          'addy',
          'adds',
          'away',
          'good',
          'glad',
          'apple',
          'green',
          'grass',
          'glass',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'g', 2: 'a'},
          invalidLengths: {5},
        );

        expect(wordPool.firstMatch(constrains), equals('glad'));
      });

      test('with invalid length and 3 constrains', () {
        final words = [
          'add',
          'are',
          'red',
          'aunt',
          'addy',
          'adds',
          'away',
          'good',
          'glad',
          'apple',
          'green',
          'grass',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'g', 2: 'a', 3: 's'},
          invalidLengths: {4},
        );

        expect(wordPool.firstMatch(constrains), equals('grass'));
      });

      test('with two invalid length and one constrains', () {
        final words = [
          'add',
          'are',
          'red',
          'aunt',
          'addy',
          'adds',
          'away',
          'good',
          'glad',
          'apple',
          'green',
          'grass',
          'glass',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a'},
          invalidLengths: {5, 4},
        );

        expect(wordPool.firstMatch(constrains), equals('add'));
      });

      test(
          'when cannot find a word in largest character '
          'goes to search different length', () {
        final words = [
          'add',
          'are',
          'red',
          'aunt',
          'addy',
          'adds',
          'away',
          'good',
          'glad',
          'apple',
          'green',
          'grass',
          'glass',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a', 1: 'r', 2: 'e'},
          invalidLengths: {},
        );

        expect(wordPool.firstMatch(constrains), equals('are'));
      });

      test('complex search with 6 constrains', () {
        final words = [
          'add',
          'are',
          'red',
          'aunt',
          'addy',
          'adds',
          'away',
          'good',
          'glad',
          'apple',
          'green',
          'astrophotographers',
          'stockspeoplelookup',
          'glass',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final constrains = ConstrainedWordCandidate(
          direction: Direction.down,
          location: Location.zero,
          constraints: {0: 'a', 3: 'r', 6: 'h', 10: 'g', 13: 'p', 15: 'e'},
          invalidLengths: {},
        );

        expect(wordPool.firstMatch(constrains), equals('astrophotographers'));
      });
    });

    group('removeWord', () {
      test('deletes of 4 characters first Addy and after Away', () {
        final words = ['Aunt', 'Addy', 'Adds', 'Away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final removedAddy = <int, Map<int, Map<String, Set<String>>>>{
          4: {
            0: {
              'a': {'Adds', 'Aunt', 'Away'},
            },
            1: {
              'u': {'Aunt'},
              'd': {'Adds'},
              'w': {'Away'},
            },
            2: {
              'n': {'Aunt'},
              'd': {'Adds'},
              'a': {'Away'},
            },
            3: {
              't': {'Aunt'},
              'y': {'Away'},
              's': {'Adds'},
            },
          },
        };

        wordPool.remove('Addy');

        expect(wordPool.sortedWords, equals(removedAddy));

        final removedAddyAndAway = <int, Map<int, Map<String, Set<String>>>>{
          4: {
            0: {
              'a': {'Adds', 'Aunt'},
            },
            1: {
              'u': {'Aunt'},
              'd': {'Adds'},
              'w': {},
            },
            2: {
              'n': {'Aunt'},
              'd': {'Adds'},
              'a': {},
            },
            3: {
              't': {'Aunt'},
              'y': {},
              's': {'Adds'},
            },
          },
        };

        wordPool.remove('Away');

        expect(wordPool.sortedWords, equals(removedAddyAndAway));
      });

      test('deletes a word of 3 characters and 5 characters', () {
        final words = [
          'Red',
          'Aunt',
          'Addy',
          'Adds',
          'Away',
          'Blue',
          'Apple',
          'Green',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final removedRed = <int, Map<int, Map<String, Set<String>>>>{
          3: {
            0: {
              'r': {},
            },
            1: {
              'e': {},
            },
            2: {
              'd': {},
            },
          },
          4: {
            0: {
              'a': {'Adds', 'Addy', 'Aunt', 'Away'},
              'b': {'Blue'},
            },
            1: {
              'u': {'Aunt'},
              'd': {'Adds', 'Addy'},
              'w': {'Away'},
              'l': {'Blue'},
            },
            2: {
              'n': {'Aunt'},
              'd': {'Adds', 'Addy'},
              'a': {'Away'},
              'u': {'Blue'},
            },
            3: {
              't': {'Aunt'},
              'y': {'Addy', 'Away'},
              's': {'Adds'},
              'e': {'Blue'},
            },
          },
          5: {
            0: {
              'a': {'Apple'},
              'g': {'Green'},
            },
            1: {
              'p': {'Apple'},
              'r': {'Green'},
            },
            2: {
              'p': {'Apple'},
              'e': {'Green'},
            },
            3: {
              'l': {'Apple'},
              'e': {'Green'},
            },
            4: {
              'e': {'Apple'},
              'n': {'Green'},
            },
          },
        };

        wordPool.remove('Red');

        expect(wordPool.sortedWords, equals(removedRed));

        final removedGreen = <int, Map<int, Map<String, Set<String>>>>{
          3: {
            0: {
              'r': {},
            },
            1: {
              'e': {},
            },
            2: {
              'd': {},
            },
          },
          4: {
            0: {
              'a': {'Adds', 'Addy', 'Aunt', 'Away'},
              'b': {'Blue'},
            },
            1: {
              'u': {'Aunt'},
              'd': {'Adds', 'Addy'},
              'w': {'Away'},
              'l': {'Blue'},
            },
            2: {
              'n': {'Aunt'},
              'd': {'Adds', 'Addy'},
              'a': {'Away'},
              'u': {'Blue'},
            },
            3: {
              't': {'Aunt'},
              'y': {'Addy', 'Away'},
              's': {'Adds'},
              'e': {'Blue'},
            },
          },
          5: {
            0: {
              'a': {'Apple'},
              'g': {},
            },
            1: {
              'p': {'Apple'},
              'r': {},
            },
            2: {
              'p': {'Apple'},
              'e': {},
            },
            3: {
              'l': {'Apple'},
              'e': {},
            },
            4: {
              'e': {'Apple'},
              'n': {},
            },
          },
        };

        wordPool.remove('Green');

        expect(wordPool.sortedWords, equals(removedGreen));
      });
    });

    group('removeWords', () {
      test('deletes of 4 characters Addy and Away', () {
        final words = ['Aunt', 'Addy', 'Adds', 'Away'];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final removedAddyAndAway = <int, Map<int, Map<String, Set<String>>>>{
          4: {
            0: {
              'a': {'Adds', 'Aunt'},
            },
            1: {
              'u': {'Aunt'},
              'd': {'Adds'},
              'w': {},
            },
            2: {
              'n': {'Aunt'},
              'd': {'Adds'},
              'a': {},
            },
            3: {
              't': {'Aunt'},
              'y': {},
              's': {'Adds'},
            },
          },
        };

        wordPool.removeAll(['Addy', 'Away']);

        expect(
          wordPool.sortedWords,
          equals(removedAddyAndAway),
        );
      });

      test('deletes a word of 3 characters and 5 characters', () {
        final words = [
          'Red',
          'Aunt',
          'Addy',
          'Adds',
          'Away',
          'Blue',
          'Apple',
          'Green',
        ];

        final wordPool =
            WordPool(maxLengthWord: 18, minLengthWord: 3, words: words);

        final removedGreen = <int, Map<int, Map<String, Set<String>>>>{
          3: {
            0: {
              'r': {},
            },
            1: {
              'e': {},
            },
            2: {
              'd': {},
            },
          },
          4: {
            0: {
              'a': {'Adds', 'Addy', 'Aunt', 'Away'},
              'b': {'Blue'},
            },
            1: {
              'u': {'Aunt'},
              'd': {'Adds', 'Addy'},
              'w': {'Away'},
              'l': {'Blue'},
            },
            2: {
              'n': {'Aunt'},
              'd': {'Adds', 'Addy'},
              'a': {'Away'},
              'u': {'Blue'},
            },
            3: {
              't': {'Aunt'},
              'y': {'Addy', 'Away'},
              's': {'Adds'},
              'e': {'Blue'},
            },
          },
          5: {
            0: {
              'a': {},
              'g': {},
            },
            1: {
              'p': {},
              'r': {},
            },
            2: {
              'p': {},
              'e': {},
            },
            3: {
              'l': {},
              'e': {},
            },
            4: {
              'e': {},
              'n': {},
            },
          },
        };

        wordPool.removeAll(['Green', 'Red', 'Apple']);

        expect(
          wordPool.sortedWords,
          equals(removedGreen),
        );
      });
    });
  });
}
