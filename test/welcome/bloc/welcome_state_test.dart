// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/welcome/welcome.dart';

void main() {
  group('$WelcomeState', () {
    test('initials uses fallback values', () {
      const state = WelcomeState.initial();

      expect(state.solvedWords, WelcomeState.fallbackSolvedWords);
      expect(state.totalWords, WelcomeState.fallbackTotalWords);
    });

    test('supports value equality', () {
      final state1 = WelcomeState(solvedWords: 1, totalWords: 2);
      final state2 = WelcomeState(solvedWords: 1, totalWords: 2);
      final state3 = WelcomeState(solvedWords: 2, totalWords: 2);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    group('copyWith', () {
      test('does nothing when no parameters are specified', () {
        final state = WelcomeState(solvedWords: 1, totalWords: 2);
        expect(state.copyWith(), equals(state));
      });

      test('copies with new values', () {
        final state = WelcomeState(solvedWords: 1, totalWords: 2);
        final newState = state.copyWith(solvedWords: 3, totalWords: 4);
        final copiedState = state.copyWith(
          solvedWords: newState.solvedWords,
          totalWords: newState.totalWords,
        );

        expect(copiedState, equals(newState));
      });
    });
  });
}
