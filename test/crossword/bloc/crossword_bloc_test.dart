// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

void main() {
  group('CrosswordBloc', () {
    final words = [
      Word(
        axis: Axis.horizontal,
        position: const Point(0, 0),
        answer: 'flutter',
        clue: 'flutter',
        hints: const ['dart', 'mobile', 'cross-platform'],
        solvedTimestamp: null,
      ),
      Word(
        axis: Axis.vertical,
        position: const Point(4, 1),
        answer: 'android',
        clue: 'flutter',
        hints: const ['dart', 'mobile', 'cross-platform'],
        solvedTimestamp: null,
      ),
      Word(
        axis: Axis.vertical,
        position: const Point(8, 3),
        answer: 'dino',
        clue: 'flutter',
        hints: const ['dart', 'mobile', 'cross-platform'],
        solvedTimestamp: null,
      ),
      Word(
        position: const Point(4, 6),
        axis: Axis.horizontal,
        answer: 'sparky',
        clue: 'flutter',
        hints: const ['dart', 'mobile', 'cross-platform'],
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

    setUp(() {
      crosswordRepository = _MockCrosswordRepository();
    });

    test('can be instantiated', () {
      expect(CrosswordBloc(crosswordRepository), isA<CrosswordBloc>());
    });

    group('BoardSectionRequested', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'adds first sections when BoardSectionRequested is '
        'called for the first time',
        build: () => CrosswordBloc(crosswordRepository),
        setUp: () {
          when(
            () => crosswordRepository.watchSectionFromPosition(1, 1),
          ).thenAnswer((_) => Stream.value(section));
        },
        seed: () => const CrosswordInitial(),
        act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: sectionSize,
            sections: {
              (1, 1): section,
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'adds new sections when BoardSectionRequested is added',
        build: () => CrosswordBloc(crosswordRepository),
        setUp: () {
          when(
            () => crosswordRepository.watchSectionFromPosition(1, 1),
          ).thenAnswer((_) => Stream.value(section));
        },
        seed: () => const CrosswordLoaded(
          sectionSize: sectionSize,
          sections: {},
        ),
        act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: sectionSize,
            sections: {
              (1, 1): section,
            },
          ),
        ],
      );
    });

    blocTest<CrosswordBloc, CrosswordState>(
      'selects a word on WordSelected',
      build: () => CrosswordBloc(crosswordRepository),
      act: (bloc) => bloc.add(const WordSelected((0, 0), 'flutter')),
      seed: () => CrosswordLoaded(
        sectionSize: sectionSize,
        sections: {
          (2, 2): BoardSection(
            id: '0',
            position: const Point(2, 2),
            size: sectionSize,
            words: [
              Word(
                axis: Axis.horizontal,
                position: const Point(0, 0),
                answer: 'flutter',
                clue: 'flutter',
                hints: const ['dart', 'mobile', 'cross-platform'],
                solvedTimestamp: null,
              ),
            ],
            borderWords: const [],
          ),
        },
      ),
      expect: () => <CrosswordState>[
        CrosswordLoaded(
          sectionSize: sectionSize,
          selectedWord: const WordSelection(
            section: (0, 0),
            wordId: 'flutter',
          ),
          sections: {
            (2, 2): BoardSection(
              id: '0',
              position: const Point(2, 2),
              size: sectionSize,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: const Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        ),
      ],
    );
  });
}
