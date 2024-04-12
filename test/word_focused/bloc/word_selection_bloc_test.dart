// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/bloc/word_selection_bloc.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('$WordSelectionBloc', () {
    test('initial state is WordSelectionState.initial', () {
      final bloc = WordSelectionBloc();
      expect(bloc.state, equals(WordSelectionState.initial()));
    });

    group('$WordSolveRequested', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits solving status with word identifier',
        build: WordSelectionBloc.new,
        act: (bloc) => bloc.add(
          WordSolveRequested(wordIdentifier: '1'),
        ),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.solving,
            wordIdentifier: '1',
          ),
        ],
      );
    });

    group('$WordFocusedSuccessRequested', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits solved status',
        build: WordSelectionBloc.new,
        act: (bloc) => bloc.add(WordFocusedSuccessRequested()),
        expect: () => <WordSelectionState>[
          WordSelectionState.initial()
              .copyWith(status: WordSelectionStatus.solved),
        ],
      );
    });

    group('$WordSolveAttempted', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'does nothing if not solving',
        build: WordSelectionBloc.new,
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'answer')),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'does nothing if already solved',
        build: WordSelectionBloc.new,
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solved,
          wordIdentifier: '1',
        ),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'answer')),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'validates a valid answer',
        build: WordSelectionBloc.new,
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solving,
          wordIdentifier: '1',
        ),
        wait: Duration(seconds: 2),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'correct')),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.validating,
            wordIdentifier: '1',
          ),
          WordSelectionState(
            status: WordSelectionStatus.solved,
            wordIdentifier: '1',
            wordPoints: 10,
          ),
        ],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'invalidates an invalid answer',
        build: WordSelectionBloc.new,
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solving,
          wordIdentifier: '1',
        ),
        wait: Duration(seconds: 2),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'incorrect')),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.validating,
            wordIdentifier: '1',
          ),
          WordSelectionState(
            status: WordSelectionStatus.incorrect,
            wordIdentifier: '1',
          ),
        ],
      );
    });
  });
}
