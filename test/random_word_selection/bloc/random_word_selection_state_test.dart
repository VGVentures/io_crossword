// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';

void main() {
  group('$RandomWordSelectionState', () {
    final word = Word(
      id: 'id',
      answer: 'answer',
      axis: WordAxis.horizontal,
      clue: 'clue',
      position: Point(0, 0),
    );

    test('initializes correctly', () {
      final state = RandomWordSelectionState();

      expect(state.status, RandomWordSelectionStatus.initial);
      expect(state.randomWord, isNull);
      expect(state.sectionPosition, isNull);
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
          randomWord: word,
          sectionPosition: (1, 1),
        );

        final copy = state.copyWith(
          status: newState.status,
          randomWord: newState.randomWord,
          sectionPosition: newState.sectionPosition,
        );

        expect(copy, equals(newState));
      });
    });
  });
}
