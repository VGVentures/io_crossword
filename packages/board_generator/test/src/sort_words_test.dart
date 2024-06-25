import 'package:board_generator/src/sort_words.dart';
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
}
