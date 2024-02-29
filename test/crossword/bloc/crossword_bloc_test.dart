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
          sections: [
            BoardSection(
              id: '1',
              position: Point(0, 0),
              width: 40,
              height: 40,
              words: [
                Word(
                  id: '1',
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: ['dart', 'mobile', 'cross-platform'],
                  visible: true,
                  solvedTimestamp: null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  });
}
