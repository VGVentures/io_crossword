// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('WordFocusedBloc', () {
    test('initial state is WordFocusedState.clue', () {
      final bloc = WordFocusedBloc();

      expect(bloc.state, equals(WordFocusedState.clue));
    });

    blocTest<WordFocusedBloc, WordFocusedState>(
      'emits WordFocusedState.solving when WordFocusedSolveRequested is added',
      build: WordFocusedBloc.new,
      act: (bloc) => bloc.add(WordFocusedSolveRequested()),
      expect: () => const <WordFocusedState>[WordFocusedState.solving],
    );

    blocTest<WordFocusedBloc, WordFocusedState>(
      'emits WordFocusedState.success when WordFocusedSuccessRequested '
      'is added',
      build: WordFocusedBloc.new,
      act: (bloc) => bloc.add(WordFocusedSuccessRequested()),
      expect: () => const <WordFocusedState>[WordFocusedState.success],
    );
  });
}
