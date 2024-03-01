import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

void main() {
  group('CrosswordBloc', () {
    test('can be instantiated', () {
      // ignore: prefer_const_constructors
      expect(CrosswordBloc(), isA<CrosswordBloc>());
    });

    blocTest<CrosswordBloc, CrosswordState>(
      'emits [CrosswordLoaded] when InitialBoardLoadRequested is added',
      build: CrosswordBloc.new,
      act: (bloc) => bloc.add(const InitialBoardLoadRequested()),
      expect: () => const <CrosswordState>[
        CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (2, 2): BoardSection(
              id: '1',
              position: Point(2, 2),
              width: 40,
              height: 40,
              words: [
                Word(
                  id: '1',
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
              ],
            ),
          },
        ),
      ],
    );

    blocTest<CrosswordBloc, CrosswordState>(
      'adds new sections when BoardSectionRequested is added',
      build: CrosswordBloc.new,
      seed: () => const CrosswordLoaded(
        width: 40,
        height: 40,
        sectionSize: 400,
        sections: {},
      ),
      act: (bloc) => bloc.add(const BoardSectionRequested((1, 1))),
      expect: () => const <CrosswordState>[
        CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (1, 1): BoardSection(
              id: '',
              position: Point(1, 1),
              width: 40,
              height: 40,
              words: [
                Word(
                  id: '',
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
                Word(
                  id: '',
                  axis: Axis.vertical,
                  position: Point(4, 1),
                  answer: 'android',
                  clue: 'flutter',
                  hints: ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
                Word(
                  id: '',
                  axis: Axis.vertical,
                  position: Point(8, 3),
                  answer: 'dino',
                  clue: 'flutter',
                  hints: ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
                Word(
                  id: '',
                  position: Point(4, 6),
                  axis: Axis.horizontal,
                  answer: 'sparky',
                  clue: 'flutter',
                  hints: ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
              ],
            ),
          },
        ),
      ],
    );
  });
}
