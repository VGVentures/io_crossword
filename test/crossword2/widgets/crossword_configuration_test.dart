// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

void main() {
  group('$CrosswordConfiguration', () {
    test('can be instantiated', () {
      final configuration = CrosswordConfiguration(
        bottomRight: (2, 2),
        chunkSize: 5,
      );

      expect(configuration.bottomRight, equals((2, 2)));
      expect(configuration.chunkSize, equals(5));
    });

    test('supports value equality', () {
      final configuration1 = CrosswordConfiguration(
        bottomRight: (2, 2),
        chunkSize: 5,
      );
      final configuration2 = CrosswordConfiguration(
        bottomRight: (2, 2),
        chunkSize: 5,
      );
      final configuration3 = CrosswordConfiguration(
        bottomRight: (5, 5),
        chunkSize: 10,
      );

      expect(configuration1, equals(configuration2));
      expect(configuration1, isNot(equals(configuration3)));
      expect(configuration2, isNot(equals(configuration3)));
    });
  });
}
