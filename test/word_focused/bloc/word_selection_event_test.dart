// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

void main() {
  group('$WordSelected', () {
    test('supports equality', () {
      expect(
        WordSelected(wordIdentifier: '1'),
        equals(WordSelected(wordIdentifier: '1')),
      );
    });
  });

  group('$WordUnselected', () {
    test('supports equality', () {
      expect(
        WordUnselected(),
        equals(WordUnselected()),
      );
    });
  });

  group('$WordSolveRequested', () {
    test('supports equality', () {
      expect(
        WordSolveRequested(),
        equals(WordSolveRequested()),
      );
    });
  });

  group('$WordSolveAttempted', () {
    test('supports equality', () {
      expect(
        WordSolveAttempted(answer: 'answer'),
        equals(WordSolveAttempted(answer: 'answer')),
      );
    });
  });

  group('WordFocusedSuccessRequested', () {
    test('supports equality', () {
      expect(
        WordFocusedSuccessRequested(),
        equals(WordFocusedSuccessRequested()),
      );
    });
  });
}
