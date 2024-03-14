// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockWord extends Mock implements Word {}

class FakeImage extends Fake implements ui.Image {}

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
    final sectionImage = FakeImage();
    final section = BoardSection(
      id: '',
      position: const Point(1, 1),
      size: sectionSize,
      words: words,
      borderWords: const [],
    );

    late CrosswordRepository crosswordRepository;

    Future<ui.Image> decodeImage(Uint8List bytes) async => sectionImage;

    setUp(() {
      crosswordRepository = _MockCrosswordRepository();
    });

    test('can be instantiated', () {
      expect(
        CrosswordBloc(crosswordRepository: crosswordRepository),
        isA<CrosswordBloc>(),
      );
    });

    group('BoardSectionRequested', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'adds first sections when BoardSectionRequested is '
        'called for the first time',
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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

    group('WordSelected', () {
      late Word word;

      setUp(() {
        word = _MockWord();
      });

      blocTest<CrosswordBloc, CrosswordState>(
        'selects a word in the current section',
        setUp: () {
          when(() => word.id).thenReturn('word-id');
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
              wordId: 'word-id',
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
              wordId: 'word-id',
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
              wordId: 'word-id',
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
              wordId: 'word-id',
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
              wordId: 'word-id',
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
              wordId: 'word-id',
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
              wordId: 'word-id',
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.horizontal);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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
          when(() => word.id).thenReturn('word-id');
          when(() => word.axis).thenReturn(Axis.vertical);
        },
        build: () => CrosswordBloc(crosswordRepository: crosswordRepository),
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

    group('RenderModeSwitched', () {
      blocTest<CrosswordBloc, CrosswordState>(
        'emits state with sections snapshots if render switch from game'
        ' to snapshot',
        build: () => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          imageDecodeCall: decodeImage,
        ),
        setUp: () {
          when(
            () => crosswordRepository.fetchSectionSnapshotBytes(any()),
          ).thenAnswer((_) async => Future.value(Uint8List(0)));
        },
        seed: () => const CrosswordLoaded(
          sectionSize: sectionSize,
          sections: {
            (0, 0): BoardSection(
              id: '0',
              position: Point(0, 0),
              size: sectionSize,
              words: [],
              borderWords: [],
              snapshotUrl: 'url',
            ),
          },
        ),
        act: (bloc) => bloc.add(const RenderModeSwitched(RenderMode.snapshot)),
        expect: () => <CrosswordState>[
          CrosswordLoaded(
            sectionSize: sectionSize,
            sections: {
              (0, 0): BoardSection(
                id: '0',
                position: Point(0, 0),
                size: sectionSize,
                words: [],
                borderWords: [],
                snapshotUrl: 'url',
              ),
            },
            sectionsSnapshots: {
              (0, 0): sectionImage,
            },
            renderMode: RenderMode.snapshot,
          ),
        ],
      );
    });
  });
}
