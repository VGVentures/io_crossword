import 'package:board_generator_playground/src/sort_words.dart';
import 'package:test/test.dart';

void main() {
  group('sortWords', () {
    test('sorts list of 4 characters', () {
      final words = ['Aunt', 'Addy', 'Adds', 'Away'];

      final organizedWords = <int, Map<int, Map<String, Set<String>>>>{
        4: {
          0: {
            'a': {'Adds', 'Addy', 'Aunt', 'Away'},
          },
          1: {
            'u': {'Aunt'},
            'd': {'Adds', 'Addy'},
            'w': {'Away'},
          },
          2: {
            'n': {'Aunt'},
            'd': {'Adds', 'Addy'},
            'a': {'Away'},
          },
          3: {
            't': {'Aunt'},
            'y': {'Addy', 'Away'},
            's': {'Adds'},
          },
        },
      };

      expect(sortWords(words), equals(organizedWords));
    });

    test('sorts list of 3, 4 and 5 characters', () {
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

      final organizedWords = <int, Map<int, Map<String, Set<String>>>>{
        3: {
          0: {
            'r': {'Red'},
          },
          1: {
            'e': {'Red'},
          },
          2: {
            'd': {'Red'},
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

      expect(sortWords(words), equals(organizedWords));
    });
  });

  group('OrderedWords extension', () {
    group('removeWord', () {
      test('deletes of 4 characters first Addy and after Away', () {
        final words = ['Aunt', 'Addy', 'Adds', 'Away'];

        final sortedWords = sortWords(words);

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

        expect(sortedWords..removeWord('Addy'), equals(removedAddy));

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

        expect(sortedWords..removeWord('Away'), equals(removedAddyAndAway));
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

        final sortedWords = sortWords(words);

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

        expect(sortedWords..removeWord('Red'), equals(removedRed));

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

        expect(sortedWords..removeWord('Green'), equals(removedGreen));
      });
    });

    group('removeWords', () {
      test('deletes of 4 characters Addy and Away', () {
        final words = ['Aunt', 'Addy', 'Adds', 'Away'];

        final sortedWords = sortWords(words);

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

        expect(
          sortedWords..removeWords(['Addy', 'Away']),
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

        final sortedWords = sortWords(words);

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

        expect(
          sortedWords..removeWords(['Green', 'Red', 'Apple']),
          equals(removedGreen),
        );
      });
    });
  });
}
