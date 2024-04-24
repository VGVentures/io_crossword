// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/bloc/word_selection_bloc.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

class _MockWord extends Mock implements Word {
  @override
  String get id => 'id';
}

class _MockCrosswordResource extends Mock implements CrosswordResource {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _FakeUnsolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;
}

void main() {
  group('$WordSelectionBloc', () {
    late CrosswordResource crosswordResource;
    late CrosswordRepository crosswordRepository;
    late SelectedWord selectedWord;

    setUp(() {
      crosswordResource = _MockCrosswordResource();
      crosswordRepository = _MockCrosswordRepository();
      selectedWord = SelectedWord(
        section: (0, 0),
        word: _MockWord(),
      );
    });

    test('initial state is WordSelectionState.initial', () {
      final bloc = WordSelectionBloc(
        crosswordResource: crosswordResource,
        crosswordRepository: crosswordRepository,
      );
      expect(bloc.state, equals(WordSelectionState.initial()));
    });

    group('$WordSelected', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits preSolving status',
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        act: (bloc) => bloc.add(WordSelected(selectedWord: selectedWord)),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            word: selectedWord,
          ),
        ],
      );
    });

    group('$LetterSelected', () {
      /// A letter that has words in both horizontal and vertical directions.
      late CrosswordLetterData crossedLetter;

      /// A letter that only has a word in the horizontal direction.
      late CrosswordLetterData horizontalLetter;

      /// A letter that only has a word in the vertical direction.
      late CrosswordLetterData verticalLetter;

      setUp(() {
        final horizontalWord = _MockWord();
        final verticalWord = _MockWord();

        crossedLetter = CrosswordLetterData(
          character: 'A',
          index: (0, 0),
          chunkIndex: (1, 1),
          words: (horizontalWord, verticalWord),
        );

        horizontalLetter = CrosswordLetterData(
          character: 'A',
          index: (0, 0),
          chunkIndex: (1, 1),
          words: (horizontalWord, null),
        );

        verticalLetter = CrosswordLetterData(
          character: 'A',
          index: (0, 0),
          chunkIndex: (1, 1),
          words: (null, verticalWord),
        );
      });

      group('emits preSolving status', () {
        blocTest<WordSelectionBloc, WordSelectionState>(
          'toggles between words when letter is crossed',
          build: () => WordSelectionBloc(
            crosswordResource: crosswordResource,
            crosswordRepository: crosswordRepository,
          ),
          act: (bloc) => bloc
            ..add(LetterSelected(letter: crossedLetter))
            ..add(LetterSelected(letter: crossedLetter))
            ..add(LetterSelected(letter: crossedLetter)),
          expect: () => <WordSelectionState>[
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: crossedLetter.chunkIndex,
                word: crossedLetter.words.$1!,
              ),
            ),
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: crossedLetter.chunkIndex,
                word: crossedLetter.words.$2!,
              ),
            ),
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: crossedLetter.chunkIndex,
                word: crossedLetter.words.$1!,
              ),
            ),
          ],
        );

        blocTest<WordSelectionBloc, WordSelectionState>(
          'once with horizontal word when letter is vertical',
          build: () => WordSelectionBloc(
            crosswordResource: crosswordResource,
            crosswordRepository: crosswordRepository,
          ),
          act: (bloc) => bloc
            ..add(LetterSelected(letter: horizontalLetter))
            ..add(LetterSelected(letter: horizontalLetter)),
          expect: () => <WordSelectionState>[
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: crossedLetter.chunkIndex,
                word: crossedLetter.words.$1!,
              ),
            ),
          ],
        );

        blocTest<WordSelectionBloc, WordSelectionState>(
          'once with vertical word when letter is vertical',
          build: () => WordSelectionBloc(
            crosswordResource: crosswordResource,
            crosswordRepository: crosswordRepository,
          ),
          act: (bloc) => bloc
            ..add(LetterSelected(letter: verticalLetter))
            ..add(LetterSelected(letter: verticalLetter)),
          expect: () => <WordSelectionState>[
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: SelectedWord(
                section: crossedLetter.chunkIndex,
                word: crossedLetter.words.$2!,
              ),
            ),
          ],
        );
      });
    });

    group('$WordUnselected', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits initial state',
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        seed: () => WordSelectionState(
          status: WordSelectionStatus.preSolving,
          word: selectedWord,
        ),
        act: (bloc) => bloc.add(WordUnselected()),
        expect: () => <WordSelectionState>[WordSelectionState.initial()],
      );
    });

    group('$RandomWordSelected', () {
      final word = _FakeUnsolvedWord();
      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits state with new selected word if a section is found',
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        setUp: () => {
          when(crosswordRepository.getRandomUncompletedSection).thenAnswer(
            (_) => Future.value(
              BoardSection(
                id: '',
                position: Point(1, 1),
                size: 10,
                words: [word],
                borderWords: const [],
              ),
            ),
          ),
        },
        act: (bloc) => bloc.add(RandomWordSelected()),
        expect: () => <WordSelectionState>[
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            word: SelectedWord(
              word: word,
              section: (1, 1),
            ),
          ),
        ],
      );
    });

    group('$WordSolveRequested', () {
      blocTest<WordSelectionBloc, WordSelectionState>(
        'does nothing if there is no word identifier',
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        act: (bloc) => bloc.add(
          WordSolveRequested(),
        ),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'emits solving status when there is a word identifier',
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
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
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'answer')),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'does nothing if already solved',
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        seed: () => WordSelectionState(
          status: WordSelectionStatus.solved,
          word: selectedWord,
        ),
        act: (bloc) => bloc.add(WordSolveAttempted(answer: 'answer')),
        expect: () => <WordSelectionState>[],
      );

      blocTest<WordSelectionBloc, WordSelectionState>(
        'validates a valid answer',
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        setUp: () {
          answerWord = _MockWord();
          when(() => selectedWord.word.copyWith(answer: 'correct'))
              .thenReturn(answerWord);
          when(
            () => crosswordResource.answerWord(
              wordId: selectedWord.word.id,
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
        build: () => WordSelectionBloc(
          crosswordResource: crosswordResource,
          crosswordRepository: crosswordRepository,
        ),
        setUp: () {
          when(
            () => crosswordResource.answerWord(
              wordId: selectedWord.word.id,
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
