// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockWord extends Mock implements Word {}

void main() {
  group('CrosswordBloc', () {
    final words = [
      Word(
        id: '1',
        axis: Axis.horizontal,
        position: const Point(0, 0),
        answer: 'flutter',
        clue: 'flutter',
        solvedTimestamp: null,
      ),
      Word(
        id: '2',
        axis: Axis.vertical,
        position: const Point(4, 1),
        answer: 'android',
        clue: 'flutter',
        solvedTimestamp: null,
      ),
      Word(
        id: '3',
        axis: Axis.vertical,
        position: const Point(8, 3),
        answer: 'dino',
        clue: 'flutter',
        solvedTimestamp: null,
      ),
      Word(
        id: '4',
        position: const Point(4, 6),
        axis: Axis.horizontal,
        answer: 'sparky',
        clue: 'flutter',
        solvedTimestamp: null,
      ),
    ];
    const sectionSize = 40;
    final section = BoardSection(
      id: '',
      position: const Point(1, 1),
      size: sectionSize,
      words: words,
      borderWords: const [],
    );

    late CrosswordRepository crosswordRepository;
    late BoardInfoRepository boardInfoRepository;

    setUp(() {
      crosswordRepository = _MockCrosswordRepository();
      boardInfoRepository = _MockBoardInfoRepository();
    });

    test('can be instantiated', () {
      expect(
        CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        isA<CrosswordBloc>(),
      );
    });

    group('BoardSectionRequested', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits [failure] when watchSectionFromPosition returns error',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(
            () => crosswordRepository.watchSectionFromPosition(1, 1),
          ).thenAnswer((_) => Stream.error(Exception()));
        },
        act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.failure,
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [success] and adds first sections when BoardSectionRequested is '
        'called for the first time',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(
            () => crosswordRepository.watchSectionFromPosition(1, 1),
          ).thenAnswer((_) => Stream.value(section));
        },
        act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: sectionSize,
            sections: {
              (1, 1): section,
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'does nothing if already requested',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(
            () => crosswordRepository.watchSectionFromPosition(1, 1),
          ).thenAnswer((_) => Stream.value(section));
        },
        act: (bloc) => bloc
          ..add(const BoardSectionRequested((1, 1)))
          ..add(const BoardSectionRequested((1, 1))),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: sectionSize,
            sections: {
              (1, 1): section,
            },
          ),
        ],
        verify: (bloc) {
          verify(() => crosswordRepository.watchSectionFromPosition(1, 1))
              .called(1);
        },
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [success] and adds new sections '
        'when BoardSectionRequested is added',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(
            () => crosswordRepository.watchSectionFromPosition(1, 1),
          ).thenAnswer((_) => Stream.value(section));
        },
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 1): section,
          },
        ),
        act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: sectionSize,
            sections: {
              (0, 1): section,
              (1, 1): section,
            },
          ),
        ],
      );
    });

    group('WordSelected', () {
      late Word word;

      setUp(() {
        word = _MockWord();
      });

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word in the current section',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((0, 0), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
          },
        ),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: WordSelection(
              section: (0, 0),
              word: word,
            ),
            sections: {
              (0, 0): BoardSection(
                id: '0',
                position: Point(2, 2),
                size: sectionSize,
                words: [word],
                borderWords: [],
              ),
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word from the border section in the horizontal axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((1, 0), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (1, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: WordSelection(
              section: (0, 0),
              word: word,
            ),
            sections: {
              (0, 0): BoardSection(
                id: '0',
                position: Point(2, 2),
                size: sectionSize,
                words: [word],
                borderWords: [],
              ),
              (1, 0): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word from the border section in the vertical axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((0, 1), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (0, 1): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: WordSelection(
              section: (0, 0),
              word: word,
            ),
            sections: {
              (0, 0): BoardSection(
                id: '0',
                position: Point(2, 2),
                size: sectionSize,
                words: [word],
                borderWords: [],
              ),
              (0, 1): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word starting two sections from current '
        'in the horizontal axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((2, 0), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (1, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
            (2, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: WordSelection(
              section: (0, 0),
              word: word,
            ),
            sections: {
              (0, 0): BoardSection(
                id: '0',
                position: Point(2, 2),
                size: sectionSize,
                words: [word],
                borderWords: [],
              ),
              (1, 0): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
              (2, 0): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word starting two sections from current '
        'in the vertical axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((0, 2), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (0, 1): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
            (0, 2): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: WordSelection(
              section: (0, 0),
              word: word,
            ),
            sections: {
              (0, 0): BoardSection(
                id: '0',
                position: Point(2, 2),
                size: sectionSize,
                words: [word],
                borderWords: [],
              ),
              (0, 1): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
              (0, 2): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word from the previous section '
        'in the negative horizontal axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((0, 0), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (-1, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (0, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: WordSelection(
              section: (-1, 0),
              word: word,
            ),
            sections: {
              (-1, 0): BoardSection(
                id: '0',
                position: Point(2, 2),
                size: sectionSize,
                words: [word],
                borderWords: [],
              ),
              (0, 0): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word from the previous section '
        'in the negative vertical axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((0, 0), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, -1): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (0, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: WordSelection(
              section: (0, -1),
              word: word,
            ),
            sections: {
              (0, -1): BoardSection(
                id: '0',
                position: Point(2, 2),
                size: sectionSize,
                words: [word],
                borderWords: [],
              ),
              (0, 0): BoardSection(
                id: '1',
                position: Point(2, 2),
                size: sectionSize,
                words: [],
                borderWords: [word],
              ),
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'throws exception when does not find the selected word from more than '
        'or equal to three previous section in the horizontal axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((3, 0), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (1, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
            (2, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
            (3, 0): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        errors: () => [
          isA<Exception>().having(
            (error) => error.toString(),
            'description',
            'Exception: Word not found in crossword',
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'throws exception when does not find the selected word from more than '
        'or equal to three previous section in the vertical axis',
        setUp: () {
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(WordSelected((0, 3), word)),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(2, 2),
              size: sectionSize,
              words: [word],
              borderWords: [],
            ),
            (0, 1): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
            (0, 2): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
            (0, 3): BoardSection(
              id: '1',
              position: Point(2, 2),
              size: sectionSize,
              words: [],
              borderWords: [word],
            ),
          },
        ),
        errors: () => [
          isA<Exception>().having(
            (error) => error.toString(),
            'description',
            'Exception: Word not found in crossword',
          ),
        ],
      );
    });

    group('WordUnselected', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits state with word selected as null',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        seed: () => CrosswordState(
          sectionSize: sectionSize,
          selectedWord: WordSelection(
            section: (0, 0),
            word: _MockWord(),
          ),
        ),
        act: (bloc) => bloc.add(WordUnselected()),
        expect: () => <CrosswordState>[
          CrosswordState(
            sectionSize: sectionSize,
            selectedWord: null,
          ),
        ],
      );
    });

    group('BoardLoadingInfoFetched', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits same state with updated size and render limits info when'
        ' state is CrosswordState',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(boardInfoRepository.getSectionSize)
              .thenAnswer((_) => Future.value(20));
          when(boardInfoRepository.getZoomLimit)
              .thenAnswer((_) => Future.value(0.8));
        },
        seed: () => CrosswordState(
          status: CrosswordStatus.success,
          sectionSize: sectionSize,
          sections: {},
        ),
        act: (bloc) => bloc.add(BoardLoadingInformationRequested()),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.success,
            sectionSize: 20,
            zoomLimit: 0.8,
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [failure] state if getRenderModeZoomLimits fails',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(boardInfoRepository.getSectionSize)
              .thenAnswer((_) => Future.value(20));
          when(boardInfoRepository.getZoomLimit).thenThrow(Exception('error'));
        },
        seed: () => CrosswordState(sectionSize: sectionSize, sections: {}),
        act: (bloc) => bloc.add(BoardLoadingInformationRequested()),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.failure,
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [failure] state if getSectionSize fails',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(boardInfoRepository.getSectionSize)
              .thenThrow(Exception('error'));
          when(boardInfoRepository.getZoomLimit)
              .thenAnswer((_) => Future.value(0.8));
        },
        seed: () => CrosswordState(sectionSize: sectionSize, sections: {}),
        act: (bloc) => bloc.add(BoardLoadingInformationRequested()),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.failure,
          ),
        ],
      );
    });

    group('GameStatusRequested', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits [failure] state if getGameStatus fails',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => boardInfoRepository.getGameStatus())
              .thenThrow(Exception('error'));
        },
        act: (bloc) => bloc.add(GameStatusRequested()),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.failure,
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits BoardStatus.resetInProgress when GameStatus is resetInProgress',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => boardInfoRepository.getGameStatus())
              .thenAnswer((_) => Stream.value(GameStatus.resetInProgress));
        },
        act: (bloc) => bloc.add(GameStatusRequested()),
        expect: () => [
          isA<CrosswordState>().having(
            (state) => state.boardStatus,
            'boardStatus',
            BoardStatus.resetInProgress,
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [success] state with game status when getGameStatus succeeds',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => boardInfoRepository.getGameStatus())
              .thenAnswer((_) => Stream.value(GameStatus.inProgress));
        },
        act: (bloc) => bloc.add(GameStatusRequested()),
        expect: () => <CrosswordState>[
          CrosswordState(
            gameStatus: GameStatus.inProgress,
          ),
        ],
      );
    });

    group('BoardStatusResumed', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits [BoardStatus.inProgress] state with board status in progress',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(BoardStatusResumed()),
        expect: () => [
          isA<CrosswordState>().having(
            (state) => state.boardStatus,
            'boardStatus',
            BoardStatus.inProgress,
          ),
        ],
      );
    });
  });
}
