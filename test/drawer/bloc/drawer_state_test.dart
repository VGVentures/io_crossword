// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/drawer/bloc/drawer_bloc.dart';

void main() {
  group('$DrawerState', () {
    test('initials uses fallback values', () {
      const state = DrawerState.initial();

      expect(state.solvedWords, DrawerState.fallbackSolvedWords);
      expect(state.totalWords, DrawerState.fallbackTotalWords);
    });

    test('supports value equality', () {
      final state1 = DrawerState(solvedWords: 1, totalWords: 2);
      final state2 = DrawerState(solvedWords: 1, totalWords: 2);
      final state3 = DrawerState(solvedWords: 2, totalWords: 2);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    group('copyWith', () {
      test('does nothing when no parameters are specified', () {
        final state = DrawerState(solvedWords: 1, totalWords: 2);
        expect(state.copyWith(), equals(state));
      });

      test('copies with new values', () {
        final state = DrawerState(solvedWords: 1, totalWords: 2);
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
