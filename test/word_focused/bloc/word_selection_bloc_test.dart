// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/word_selection/bloc/word_selection_bloc.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

class _FakeWord extends Fake implements Word {}

void main() {
  group('$WordSelectionBloc', () {
    late SelectedWord selectedWord;

    setUp(() {
      selectedWord = SelectedWord(
        word: _FakeWord(),
        section: (0, 0),
      );
    });

    test('initial state is WordSelectionState.initial', () {
      final bloc = WordSelectionBloc();
      expect(bloc.state, equals(WordSelectionState.initial()));
    });

    group('$WordSelected', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits preSolving status',
        build: WordSelectionBloc.new,
        act: (bloc) => bloc.add(WordSelected(selectedWord: selectedWord)),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            word: selectedWord,
          ),
        ],
      );
    });

    group('$WordUnselected', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits initial state',
        build: WordSelectionBloc.new,
        seed: () => WordSelectionState(
          status: WordSelectionStatus.preSolving,
          word: selectedWord,
        ),
        act: (bloc) => bloc.add(WordUnselected()),
        expect: () => <WordSelectionState>[WordSelectionState.initial()],
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
          word: selectedWord,
        ),
        act: (bloc) => bloc.add(
          WordSolveRequested(),
        ),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.solving,
            word: selectedWord,
          ),
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
          word: selectedWord,
        ),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'answer')),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'validates a valid answer',
        build: WordSelectionBloc.new,
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
        ),
        wait: Duration(seconds: 2),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'correct')),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.validating,
            word: selectedWord,
          ),
          WordSelectionState(
            status: WordSelectionStatus.solved,
            word: selectedWord,
            wordPoints: 10,
          ),
        ],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'invalidates an invalid answer',
        build: WordSelectionBloc.new,
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
        ),
        wait: Duration(seconds: 2),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'incorrect')),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.validating,
            word: selectedWord,
          ),
          WordSelectionState(
            status: WordSelectionStatus.incorrect,
            word: selectedWord,
          ),
        ],
      );
    });
  });
}
