// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('WordFocusedSolveRequested', () {
    test('supports equality', () {
      expect(
        WordFocusedSolveRequested(),
        equals(WordFocusedSolveRequested()),
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
