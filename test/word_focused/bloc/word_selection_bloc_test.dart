// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_selection/bloc/word_selection_bloc.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

void main() {
  group('$WordSelectionBloc', () {
    test('initial state is WordSelectionState.initial', () {
      final bloc = WordSelectionBloc();
      expect(bloc.state, equals(WordSelectionState.initial()));
    });

    group('$WordSelected', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits preSolving status',
        build: WordSelectionBloc.new,
        act: (bloc) => bloc.add(WordSelected(wordIdentifier: '1')),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        ],
      );
    });

    group('$WordSolveRequested', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'does nothing if there is no word identifier',
        build: WordSelectionBloc.new,
        act: (bloc) => bloc.add(
          WordSolveRequested(),
        ),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits solving status when there is a word identifier',
        build: WordSelectionBloc.new,
        seed: () => WordSelectionState(
          status: WordSelectionStatus.preSolving,
          wordIdentifier: '1',
        ),
        act: (bloc) => bloc.add(
          WordSolveRequested(),
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
