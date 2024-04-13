// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('$WordSelectionState', () {
    test('.initial initializes correctly', () {
      final state = WordSelectionState.initial();

      expect(state.status, WordSelectionStatus.preSolving);
      expect(state.wordIdentifier, isNull);
      expect(state.wordPoints, isNull);
    });

    test('supports value equality', () {
      final state1 = WordSelectionState(
        wordIdentifier: '1',
        status: WordSelectionStatus.preSolving,
        wordPoints: 10,
      );
      final state2 = WordSelectionState(
        wordIdentifier: '1',
        status: WordSelectionStatus.preSolving,
        wordPoints: 10,
      );
      final state3 = WordSelectionState(
        wordIdentifier: '2',
        status: WordSelectionStatus.solving,
        wordPoints: 20,
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
      expect(state2, isNot(equals(state3)));
    });

    group('copyWith', () {
      test('does nothing when no parameters are specified', () {
        final state = WordSelectionState(
          wordIdentifier: '1',
          status: WordSelectionStatus.preSolving,
          wordPoints: 10,
        );

        final copy = state.copyWith();

        expect(copy, equals(state));
      });

      test('copies specified parameters', () {
        final state = WordSelectionState(
          wordIdentifier: '1',
          status: WordSelectionStatus.preSolving,
          wordPoints: 10,
        );
        final newState = WordSelectionState(
          wordIdentifier: '2',
          status: WordSelectionStatus.solved,
          wordPoints: 20,
        );

        final copy = state.copyWith(
          wordIdentifier: newState.wordIdentifier,
          status: newState.status,
          wordPoints: newState.wordPoints,
        );

        expect(copy, equals(newState));
      });
    });
  });
}
