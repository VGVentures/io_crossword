// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardInfoRepository extends Mock implements BoardInfoRepository {}

class _MockWord extends Mock implements Word {}

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
        'adds first sections when BoardSectionRequested is '
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
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(
            () => crosswordRepository.watchSectionFromPosition(1, 1),
          ).thenAnswer((_) => Stream.value(section));
        },
        seed: () => const CrosswordLoaded(
          sectionSize: sectionSize,
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
        seed: () => CrosswordLoaded(
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
          CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
          CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
          CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
          CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
          CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
          CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
          CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
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
        seed: () => CrosswordLoaded(
          sectionSize: sectionSize,
          selectedWord: WordSelection(
            section: (0, 0),
            word: _MockWord(),
          ),
        ),
        act: (bloc) => bloc.add(WordUnselected()),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: sectionSize,
            selectedWord: null,
          ),
        ],
      );
    });

    group('MascotSelected', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits crossword loaded state with the selected mascot '
        'when MascotSelected is added',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        seed: () => CrosswordLoaded(sectionSize: sectionSize, sections: {}),
        act: (bloc) => bloc.add(MascotSelected(Mascots.android)),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: sectionSize,
            mascot: Mascots.android,
          ),
        ],
      );
    });

    group('BoardLoadingInfoFetched', () {
      final originSection = section.copyWith(position: Point(0, 0));
      blocTest<CrosswordBloc, CrosswordState>(
        'emits crossword loaded state with the size and render limits info when'
        ' state is not CrosswordLoaded and requests section (0, 0)',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(boardInfoRepository.getSectionSize)
              .thenAnswer((_) => Future.value(20));
          when(boardInfoRepository.getZoomLimit)
              .thenAnswer((_) => Future.value(0.8));
          when(
            () => crosswordRepository.watchSectionFromPosition(0, 0),
          ).thenAnswer(
            (_) => Stream.value(originSection),
          );
        },
        act: (bloc) => bloc.add(BoardLoadingInfoFetched()),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: 20,
            zoomLimit: 0.8,
          ),
          CrosswordLoaded(
            sectionSize: 20,
            zoomLimit: 0.8,
            sections: {
              (0, 0): originSection,
            },
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits same state with updated size and render limits info when'
        ' state is CrosswordLoaded',
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
        seed: () => CrosswordLoaded(sectionSize: sectionSize, sections: {}),
        act: (bloc) => bloc.add(BoardLoadingInfoFetched()),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: 20,
            zoomLimit: 0.8,
          ),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits CrosswordError state if getRenderModeZoomLimits fails',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        setUp: () {
          when(boardInfoRepository.getSectionSize)
              .thenAnswer((_) => Future.value(20));
          when(boardInfoRepository.getZoomLimit).thenThrow(Exception('error'));
        },
        seed: () => CrosswordLoaded(sectionSize: sectionSize, sections: {}),
        act: (bloc) => bloc.add(BoardLoadingInfoFetched()),
        expect: () => <CrosswordState>[
          CrosswordError('Exception: error'),
        ],
      );

      blocTest<CrosswordBloc, CrosswordState>(
        'emits CrosswordError state if getSectionSize fails',
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
        seed: () => CrosswordLoaded(sectionSize: sectionSize, sections: {}),
        act: (bloc) => bloc.add(BoardLoadingInfoFetched()),
        expect: () => <CrosswordState>[
          CrosswordError('Exception: error'),
        ],
      );
    });
    group('InitialsSelected', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits crossword loaded state with the initials entered '
        'when InitialsSelected is added',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
        ),
        seed: () => CrosswordLoaded(sectionSize: sectionSize, sections: {}),
        act: (bloc) => bloc.add(InitialsSelected(['A', 'B', 'C'])),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: sectionSize,
            sections: {},
            initials: 'ABC',
          ),
        ],
      );
    });
  });
}
