// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

class _FakeWord extends Fake implements Word {}

void main() {
  group('$WordSelected', () {
    test('supports equality', () {
      final word = SelectedWord(
        word: _FakeWord(),
        section: (0, 0),
      );
      expect(
        WordSelected(selectedWord: word),
        equals(WordSelected(selectedWord: word)),
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
}
