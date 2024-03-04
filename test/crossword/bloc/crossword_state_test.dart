// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

void main() {
  group('CrosswordState', () {
    group('CrosswordInitial', () {
      test('can be instantiated', () {
        expect(CrosswordInitial(), isA<CrosswordInitial>());
      });
      test('supports value comparisons', () {
        expect(CrosswordInitial(), CrosswordInitial());
      });
    });

    group('CrosswordLoading', () {
      test('can be instantiated', () {
        expect(CrosswordLoading(), isA<CrosswordLoading>());
      });
      test('supports value comparisons', () {
        expect(CrosswordLoading(), CrosswordLoading());
      });
    });

    group('CrosswordLoaded', () {
      test('can be instantiated', () {
        expect(
          CrosswordLoaded(
            width: 40,
            height: 40,
            sections: const [
              BoardSection(
                id: '1',
                position: Point(0, 0),
                size: 40,
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
                borderWords: [],
              ),
            ],
          ),
          isA<CrosswordLoaded>(),
        );
      });
      test('supports value comparisons', () {
        expect(
          CrosswordLoaded(
            width: 40,
            height: 40,
            sections: const [
              BoardSection(
                id: '1',
                position: Point(0, 0),
                size: 40,
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
                borderWords: [],
              ),
            ],
          ),
          CrosswordLoaded(
            width: 40,
            height: 40,
            sections: const [
              BoardSection(
                id: '1',
                position: Point(0, 0),
                size: 40,
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
                borderWords: [],
              ),
            ],
          ),
        );
      });
    });

    group('CrosswordError', () {
      test('can be instantiated', () {
        expect(CrosswordError('error'), isA<CrosswordError>());
      });
      test('supports value comparisons', () {
        expect(CrosswordError('error'), CrosswordError('error'));
      });
    });
  });
}
