// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

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

    group('BoardLoadingInfoFetched', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits same state with updated size, render limit and bottom right'
        ' info when state is CrosswordState',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(boardInfoRepository.getSectionSize)
              .thenAnswer((_) => Future.value(20));
          when(boardInfoRepository.getZoomLimit)
              .thenAnswer((_) => Future.value(0.8));
          when(boardInfoRepository.getBottomRight)
              .thenAnswer((_) => Future.value(Point(1, 1)));
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
            bottomRight: (1, 1),
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

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [failure] state if getBottomRight fails',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(boardInfoRepository.getSectionSize)
              .thenAnswer((_) => Future.value(20));
          when(boardInfoRepository.getZoomLimit)
              .thenAnswer((_) => Future.value(0.8));
          when(boardInfoRepository.getBottomRight)
              .thenThrow(Exception('error'));
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
        'emits [failure] state '
        'when getGameStatus fails',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => boardInfoRepository.getGameStatus())
              .thenAnswer((_) => Stream.error(Exception()));
        },
        act: (bloc) => bloc.add(GameStatusRequested()),
        expect: () => [
          isA<CrosswordState>().having(
            (state) => state.status,
            'status',
            CrosswordStatus.failure,
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
        'emits [inProgress] state with game status when getGameStatus succeeds',
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

    group('MascotDropped', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits state with mascotVisible to false when dropped',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        act: (bloc) => bloc.add(MascotDropped()),
        expect: () => <CrosswordState>[
          CrosswordState(
            mascotVisible: false,
          ),
        ],
      );
    });

    group('CrosswordSectionLoaded', () {
      final selectedWord = SelectedWord(
        section: (0, 0),
        word: Word(
          id: 'id',
          position: Point(0, 0),
          axis: Axis.horizontal,
          clue: 'clue',
          answer: 'answer',
        ),
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [failure] state when loadBoardSections fails',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => crosswordRepository.loadBoardSections())
              .thenAnswer((_) => Stream.error(Exception()));
        },
        act: (bloc) => bloc.add(CrosswordSectionsLoaded(selectedWord)),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.failure,
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits [success] state with sections when loadBoardSections succeeds',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => crosswordRepository.loadBoardSections())
              .thenAnswer((_) => Stream.value([section]));
        },
        act: (bloc) => bloc.add(CrosswordSectionsLoaded(selectedWord)),
        expect: () => <CrosswordState>[
          CrosswordState(
            status: CrosswordStatus.ready,
            sections: {(1, 1): section},
            sectionSize: section.size,
            initialWord: selectedWord,
          ),
        ],
      );
    });
  });
}
