// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/word_selection/bloc/word_selection_bloc.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

class _MockWord extends Mock implements Word {}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

void main() {
  group('$WordSelectionBloc', () {
    late CrosswordResource crosswordResource;
    late SelectedWord selectedWord;

    setUp(() {
      crosswordResource = _MockCrosswordResource();
      selectedWord = SelectedWord(
        section: (0, 0),
        word: _MockWord(),
      );
    });

    test('initial state is WordSelectionState.initial', () {
      final bloc = WordSelectionBloc(
        crosswordResource: crosswordResource,
      );
      expect(bloc.state, equals(WordSelectionState.initial()));
    });

    group('$WordSelected', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits preSolving status',
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
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
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
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
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
        act: (bloc) => bloc.add(
          WordSolveRequested(),
        ),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits solving status when there is a word identifier',
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
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
      late Word answerWord;

      blocTest<WordSelectionBloc, WordSelectionState>(
        'does nothing if not solving',
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'answer')),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'does nothing if already solved',
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solved,
          word: selectedWord,
        ),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'answer')),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'validates a valid answer',
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
        setUp: () {
          answerWord = _MockWord();
          when(() => selectedWord.word.copyWith(answer: 'correct'))
              .thenReturn(answerWord);
          when(
            () => crosswordResource.answerWord(
              section: selectedWord.section,
              word: selectedWord.word,
              answer: 'correct',
            ),
          ).thenAnswer((_) async => 10);
        },
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
        ),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'correct')),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.validating,
            word: selectedWord,
          ),
          WordSelectionState(
            status: WordSelectionStatus.solved,
            word: SelectedWord(
              section: selectedWord.section,
              word: answerWord,
            ),
            wordPoints: 10,
          ),
        ],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'invalidates an invalid answer',
        build: () => WordSelectionBloc(crosswordResource: crosswordResource),
        setUp: () {
          when(
            () => crosswordResource.answerWord(
              section: selectedWord.section,
              word: selectedWord.word,
              answer: 'incorrect',
            ),
          ).thenAnswer((_) async => 0);
        },
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solving,
          word: selectedWord,
        ),
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
