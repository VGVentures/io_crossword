import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

// TODO(any): remove this class when the real one is implemented
class _IdGenerator {
  int _id = 0;

  int next() => _id++;
}

void main() {
  group('CrosswordBloc', () {
    test('can be instantiated', () {
      // ignore: prefer_const_constructors
      expect(CrosswordBloc(), isA<CrosswordBloc>());
    });

    blocTest<CrosswordBloc, CrosswordState>(
      'emits [CrosswordLoaded] when InitialBoardLoadRequested is added',
      build: () => CrosswordBloc(idGenerator: _IdGenerator().next),
      act: (bloc) => bloc.add(const InitialBoardLoadRequested()),
      expect: () => <CrosswordState>[
        CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (2, 2): BoardSection(
              id: '0',
              position: const Point(2, 2),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: const Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        ),
      ],
    );

    blocTest<CrosswordBloc, CrosswordState>(
      'adds new sections when BoardSectionRequested is added',
      build: () => CrosswordBloc(idGenerator: _IdGenerator().next),
      seed: () => const CrosswordLoaded(
        width: 40,
        height: 40,
        sectionSize: 400,
        sections: {},
      ),
      act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
      expect: () => <CrosswordState>[
        CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (1, 1): BoardSection(
              id: '0',
              position: const Point(1, 1),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: const Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  visible: false,
                  solvedTimestamp: null,
                ),
                Word(
                  axis: Axis.vertical,
                  position: const Point(8, 3),
                  answer: 'dino',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
                Word(
                  position: const Point(4, 6),
                  axis: Axis.horizontal,
                  answer: 'sparky',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        ),
      ],
    );

    blocTest<CrosswordBloc, CrosswordState>(
      'selectd a word on WordSelected',
      build: () => CrosswordBloc(idGenerator: _IdGenerator().next),
      act: (bloc) => bloc.add(const WordSelected((0, 0), 'flutter')),
      seed: () => CrosswordLoaded(
        width: 40,
        height: 40,
        sectionSize: 400,
        sections: {
          (2, 2): BoardSection(
            id: '0',
            position: const Point(2, 2),
            size: 40,
            words: [
              Word(
                axis: Axis.horizontal,
                position: const Point(0, 0),
                answer: 'flutter',
                clue: 'flutter',
                hints: const ['dart', 'mobile', 'cross-platform'],
                visible: true,
                solvedTimestamp: null,
              ),
            ],
            borderWords: const [],
          ),
        },
      ),
      expect: () => <CrosswordState>[
        CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          selectedWord: const WordSelection(
            section: (0, 0),
            wordId: 'flutter',
          ),
          sections: {
            (2, 2): BoardSection(
              id: '0',
              position: const Point(2, 2),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: const Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  visible: true,
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
