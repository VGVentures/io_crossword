// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('$WordFocusedState', () {
    test('supports value comparisons', () {
      expect(WordFocusedState(), equals(WordFocusedState()));

      expect(
        WordFocusedState(status: WordFocusedStatus.solving),
        isNot(equals(WordFocusedState())),
      );

      expect(
        WordFocusedState(focus: WordSolvingFocus.hint),
        isNot(equals(WordFocusedState())),
      );
    });

    group('copyWith', () {
      test('copies with new values', () {
        expect(
          WordFocusedState().copyWith(
            status: WordFocusedStatus.solving,
            focus: WordSolvingFocus.hint,
          ),
          equals(
            WordFocusedState(
              status: WordFocusedStatus.solving,
              focus: WordSolvingFocus.hint,
            ),
          ),
        );
      });
    });
  });
}
