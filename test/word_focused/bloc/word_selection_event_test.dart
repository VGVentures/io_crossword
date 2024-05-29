// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

class _FakeBoardSection extends Fake implements BoardSection {}

class _FakeCrosswordLetterData extends Fake implements CrosswordLetterData {}

void main() {
  group('$SectionSelected', () {
    test('supports equality', () {
      final section = _FakeBoardSection();
      expect(
        SectionSelected(selectedSection: section),
        equals(SectionSelected(selectedSection: section)),
      );
    });
  });

  group('$LetterSelected', () {
    test('supports equality', () {
      final letter = _FakeCrosswordLetterData();

      final event1 = LetterSelected(letter: letter);
      final event2 = LetterSelected(letter: letter);
      final event3 = LetterSelected(letter: _FakeCrosswordLetterData());

      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
      expect(event2, isNot(equals(event3)));
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
