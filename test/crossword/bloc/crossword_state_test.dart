// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

void main() {
  group('CrosswordState', () {
    test('can be instantiated', () {
      expect(
        CrosswordState(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        ),
        isA<CrosswordState>(),
      );
    });
    test('supports value comparisons', () {
      expect(
        CrosswordState(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        ),
        CrosswordState(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        ),
      );
    });

    group('copyWith', () {
      test('returns same object when no parameters are specified', () {
        final state = CrosswordState(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        expect(state.copyWith(), state);
      });

      test('returns an instance with new sectionSize', () {
        final state = CrosswordState(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        final newState = state.copyWith(sectionSize: 800);
        expect(newState.sectionSize, 800);
      });

      test('returns an instance with new sections', () {
        final state = CrosswordState(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        final newState = state.copyWith(
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
            (0, 1): BoardSection(
              id: '2',
              position: Point(0, 1),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        expect(
          newState.sections,
          {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
            (0, 1): BoardSection(
              id: '2',
              position: Point(0, 1),
              size: 40,
              words: [
                Word(
                  id: '1',
                  axis: WordAxis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                ),
              ],
              borderWords: const [],
            ),
          },
        );
      });
    });
  });
}
