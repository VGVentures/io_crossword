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
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockStream extends Mock implements StreamSubscription<BoardSection?> {}

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

    group('$LoadedSectionsSuspended', () {
      late StreamSubscription<BoardSection?> subscription;

      setUp(() {
        subscription = _MockStream();
        when(() => subscription.cancel()).thenAnswer((_) async => {});
      });

      blocTest<CrosswordBloc, CrosswordState>(
        'pauses subscriptions for sections that are not visible',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
          subscriptionsMap: {(0, 0): subscription},
        ),
        setUp: () {
          when(() => subscription.isPaused).thenReturn(false);
        },
        act: (bloc) => bloc.add(const LoadedSectionsSuspended({(1, 1)})),
        verify: (bloc) {
          verify(() => subscription.pause()).called(1);
        },
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'does nothing for sections that are visible',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
          subscriptionsMap: {(0, 0): subscription},
        ),
        act: (bloc) => bloc.add(const LoadedSectionsSuspended({(0, 0)})),
        verify: (bloc) {
          verifyNever(() => subscription.pause());
        },
      );
    });

    group('BoardSectionRequested', () {
      late StreamSubscription<BoardSection?> subscription;

      setUp(() {
        subscription = _MockStream();
        when(() => subscription.cancel()).thenAnswer((_) async => {});
      });

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
        'resumes subscription if is paused',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
          subscriptionsMap: {(1, 1): subscription},
        ),
        setUp: () {
          when(() => subscription.isPaused).thenReturn(true);
        },
        act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
        verify: (_) {
          verify(() => subscription.resume()).called(1);
        },
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
  });
}
