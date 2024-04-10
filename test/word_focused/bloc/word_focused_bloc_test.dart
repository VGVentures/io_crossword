// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('WordFocusedBloc', () {
    test('initial state has WordFocusedStatus.clue', () {
      final bloc = WordFocusedBloc();

      expect(bloc.state.status, equals(WordFocusedStatus.clue));
    });

    blocTest<WordFocusedBloc, WordFocusedState>(
      'emits state with solving status when WordFocusedSolveRequested is added',
      build: WordFocusedBloc.new,
      act: (bloc) => bloc.add(WordFocusedSolveRequested()),
      expect: () => const <WordFocusedState>[
        WordFocusedState(status: WordFocusedStatus.solving),
      ],
    );

    blocTest<WordFocusedBloc, WordFocusedState>(
      'emits state with success status when WordFocusedSuccessRequested '
      'is added',
      build: WordFocusedBloc.new,
      act: (bloc) => bloc.add(WordFocusedSuccessRequested()),
      expect: () => const <WordFocusedState>[
        WordFocusedState(status: WordFocusedStatus.success),
      ],
    );

    group('SolvingFocusSwitched', () {
      blocTest<WordFocusedBloc, WordFocusedState>(
        'emits state with hint focus when current focus is word',
        build: WordFocusedBloc.new,
        act: (bloc) => bloc.add(SolvingFocusSwitched()),
        expect: () => const <WordFocusedState>[
          WordFocusedState(focus: WordSolvingFocus.hint),
        ],
      );

      blocTest<WordFocusedBloc, WordFocusedState>(
        'emits state with word focus when current focus is hint',
        build: WordFocusedBloc.new,
        seed: () => WordFocusedState(focus: WordSolvingFocus.hint),
        act: (bloc) => bloc.add(SolvingFocusSwitched()),
        expect: () => const <WordFocusedState>[
          WordFocusedState(),
        ],
      );
    });
  });
}
