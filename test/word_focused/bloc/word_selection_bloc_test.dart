// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('$WordSelectionBloc', () {
    test('initial state is WordSelectionState.clue', () {
      final bloc = WordSelectionBloc();

      expect(bloc.state, equals(WordSelectionState.clue));
    });

    blocTest<WordSelectionBloc, WordSelectionState>(
      'emits WordSelectionState.solving when WordFocusedSolveRequested '
      'is added',
      build: WordSelectionBloc.new,
      act: (bloc) => bloc.add(WordFocusedSolveRequested()),
      expect: () => const <WordSelectionState>[WordSelectionState.solving],
    );

    blocTest<WordSelectionBloc, WordSelectionState>(
      'emits WordSelectionState.success when WordFocusedSuccessRequested '
      'is added',
      build: WordSelectionBloc.new,
      act: (bloc) => bloc.add(WordFocusedSuccessRequested()),
      expect: () => const <WordSelectionState>[WordSelectionState.success],
    );
  });
}
