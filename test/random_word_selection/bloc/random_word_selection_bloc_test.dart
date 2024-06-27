// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/random_word_selection/random_word_selection.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _FakeUnsolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;
}

void main() {
  group('$RandomWordSelectionBloc', () {
    late CrosswordRepository crosswordRepository;
    late BoardInfoRepository boardInfoRepository;

    setUpAll(() {
      registerFallbackValue(Point(0, 0));
    });

    setUp(() {
      crosswordRepository = _MockCrosswordRepository();
      boardInfoRepository = _MockBoardInfoRepository();

      when(() => boardInfoRepository.getBottomRight()).thenAnswer(
        (_) => Future.value(Point(2, 2)),
      );
    });

    group('$RandomWordRequested', () {
      final word = _FakeUnsolvedWord();
      final section = BoardSection(
        id: '',
        position: Point(1, 1),
        words: [word],
      );

      blocTest<RandomWordSelectionBloc, RandomWordSelectionState>(
        'emits state with status success and a section when'
        ' getRandomUncompletedSection succeeds',
        build: () => RandomWordSelectionBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => crosswordRepository.getRandomUncompletedSection(any()))
              .thenAnswer((_) => Future.value(section));
        },
        act: (bloc) => bloc.add(RandomWordRequested()),
        expect: () => <RandomWordSelectionState>[
          RandomWordSelectionState(status: RandomWordSelectionStatus.loading),
          RandomWordSelectionState(
            status: RandomWordSelectionStatus.success,
            randomWord: word,
            sectionPosition: (1, 1),
          ),
        ],
      );

      blocTest<RandomWordSelectionBloc, RandomWordSelectionState>(
        'emits state with status failure when'
        ' getRandomUncompletedSection fails',
        build: () => RandomWordSelectionBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => crosswordRepository.getRandomUncompletedSection(any()))
              .thenThrow(Exception());
        },
        act: (bloc) => bloc.add(RandomWordRequested()),
        expect: () => <RandomWordSelectionState>[
          RandomWordSelectionState(status: RandomWordSelectionStatus.loading),
          RandomWordSelectionState(status: RandomWordSelectionStatus.failure),
        ],
      );

      blocTest<RandomWordSelectionBloc, RandomWordSelectionState>(
        'emits state with status notFound when event is not initial and '
        'getRandomUncompletedSection returns null',
        build: () => RandomWordSelectionBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => crosswordRepository.getRandomUncompletedSection(any()))
              .thenAnswer((_) => Future.value());
          when(() => crosswordRepository.getRandomSection())
              .thenAnswer((_) => Future.value(section));
        },
        act: (bloc) => bloc.add(RandomWordRequested()),
        expect: () => <RandomWordSelectionState>[
          RandomWordSelectionState(status: RandomWordSelectionStatus.loading),
          RandomWordSelectionState(
            status: RandomWordSelectionStatus.notFound,
            randomWord: word,
            sectionPosition: (1, 1),
          ),
        ],
      );

      blocTest<RandomWordSelectionBloc, RandomWordSelectionState>(
        'emits state with status initialNotFound when event is initial and '
        'getRandomUncompletedSection returns null',
        build: () => RandomWordSelectionBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(() => crosswordRepository.getRandomUncompletedSection(any()))
              .thenAnswer((_) => Future.value());
          when(() => crosswordRepository.getRandomSection())
              .thenAnswer((_) => Future.value(section));
        },
        act: (bloc) => bloc.add(RandomWordRequested(isInitial: true)),
        expect: () => <RandomWordSelectionState>[
          RandomWordSelectionState(status: RandomWordSelectionStatus.loading),
          RandomWordSelectionState(
            status: RandomWordSelectionStatus.initialNotFound,
            randomWord: word,
            sectionPosition: (1, 1),
          ),
        ],
      );
    });
  });
}
