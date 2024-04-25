// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';

void main() {
  group('$RandomWordSelectionState', () {
    final section = BoardSection(
      id: '',
      position: Point(1, 1),
      size: 10,
      words: const [],
      borderWords: const [],
    );

    test('initializes correctly', () {
      final state = RandomWordSelectionState();

      expect(state.status, RandomWordSelectionStatus.initial);
      expect(state.uncompletedSection, isNull);
    });

    group('copyWith', () {
      test('does nothing when no parameters are specified', () {
        final state = RandomWordSelectionState();
        final copy = state.copyWith();

        expect(copy, equals(state));
      });

      test('copies specified parameters', () {
        final state = RandomWordSelectionState();
        final newState = RandomWordSelectionState(
          status: RandomWordSelectionStatus.success,
          uncompletedSection: section,
        );

        final copy = state.copyWith(
          status: newState.status,
          uncompletedSection: newState.uncompletedSection,
        );

        expect(copy, equals(newState));
      });
    });
  });
}
