// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/random_word_selection/random_word_selection.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _FakeUnsolvedWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;
}

void main() {
  group('$RandomWordSelectionBloc', () {
    late CrosswordRepository crosswordRepository;

    setUp(() {
      crosswordRepository = _MockCrosswordRepository();
    });

    group('$RandomWordRequested', () {
      final word = _FakeUnsolvedWord();
      final section = BoardSection(
        id: '',
        position: Point(1, 1),
        size: 10,
        words: [word],
        borderWords: const [],
      );

      blocTest<RandomWordSelectionBloc, RandomWordSelectionState>(
        'emits state with status success and a section when'
        ' getRandomUncompletedSection succeeds',
        build: () => RandomWordSelectionBloc(
          crosswordRepository: crosswordRepository,
        ),
        setUp: () {
          when(crosswordRepository.getRandomUncompletedSection).thenAnswer(
            (_) => Future.value(section),
          );
        },
        act: (bloc) => bloc.add(RandomWordRequested()),
        expect: () => <RandomWordSelectionState>[
          RandomWordSelectionState(status: RandomWordSelectionStatus.loading),
          RandomWordSelectionState(
            status: RandomWordSelectionStatus.success,
            uncompletedSection: section,
          ),
        ],
      );

      blocTest<RandomWordSelectionBloc, RandomWordSelectionState>(
        'emits state with status failure when'
        ' getRandomUncompletedSection fails',
        build: () => RandomWordSelectionBloc(
          crosswordRepository: crosswordRepository,
        ),
        setUp: () {
          when(crosswordRepository.getRandomUncompletedSection)
              .thenThrow(Exception());
        },
        act: (bloc) => bloc.add(RandomWordRequested()),
        expect: () => <RandomWordSelectionState>[
          RandomWordSelectionState(status: RandomWordSelectionStatus.loading),
          RandomWordSelectionState(status: RandomWordSelectionStatus.failure),
        ],
      );

      blocTest<RandomWordSelectionBloc, RandomWordSelectionState>(
        'emits state with status notFound when'
        ' getRandomUncompletedSection returns null',
        build: () => RandomWordSelectionBloc(
          crosswordRepository: crosswordRepository,
        ),
        setUp: () {
          when(crosswordRepository.getRandomUncompletedSection).thenAnswer(
            (_) => Future.value(),
          );
        },
        act: (bloc) => bloc.add(RandomWordRequested()),
        expect: () => <RandomWordSelectionState>[
          RandomWordSelectionState(status: RandomWordSelectionStatus.loading),
          RandomWordSelectionState(status: RandomWordSelectionStatus.notFound),
        ],
      );
    });
  });
}
