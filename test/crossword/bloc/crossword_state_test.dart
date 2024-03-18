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

    group('CrosswordLoaded', () {
      test('can be instantiated', () {
        expect(
          CrosswordLoaded(
            sectionSize: 400,
            sections: {
              (0, 0): BoardSection(
                id: '1',
                position: Point(0, 0),
                size: 40,
                words: [
                  Word(
                    axis: Axis.horizontal,
                    position: Point(0, 0),
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
          isA<CrosswordLoaded>(),
        );
      });
      test('supports value comparisons', () {
        expect(
          CrosswordLoaded(
            sectionSize: 400,
            sections: {
              (0, 0): BoardSection(
                id: '1',
                position: Point(0, 0),
                size: 40,
                words: [
                  Word(
                    axis: Axis.horizontal,
                    position: Point(0, 0),
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
          CrosswordLoaded(
            sectionSize: 400,
            sections: {
              (0, 0): BoardSection(
                id: '1',
                position: Point(0, 0),
                size: 40,
                words: [
                  Word(
                    axis: Axis.horizontal,
                    position: Point(0, 0),
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
        );
      });

      test('copyWith returns same object', () {
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        expect(state.copyWith(), state);
      });

      test('copyWith returns an instance with new width', () {
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        final newState = state.copyWith(width: 80);
        expect(newState.width, 80);
      });

      test('copyWith returns an instance with new height', () {
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        final newState = state.copyWith(height: 80);
        expect(newState.height, 80);
      });

      test('copyWith returns an instance with new sectionSize', () {
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );
        final newState = state.copyWith(sectionSize: 800);
        expect(newState.sectionSize, 800);
      });

      test('copyWith returns an instance with new sections', () {
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
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
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
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
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
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
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
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
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );
      });

      test('copyWith returns an instance with new mascot', () {
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: const {},
        );
        final newState = state.copyWith(mascot: Mascots.dino);
        expect(newState.mascot, equals(Mascots.dino));
      });

      group('withSelectedWord returns a copy with selected word', () {
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '1',
              position: Point(0, 0),
              size: 40,
              words: [
                Word(
                  axis: Axis.horizontal,
                  position: Point(0, 0),
                  answer: 'flutter',
                  clue: 'flutter',
                  hints: const ['dart', 'mobile', 'cross-platform'],
                  solvedTimestamp: null,
                ),
              ],
              borderWords: const [],
            ),
          },
        );

        test('returns a copy with selected word', () {
          final newState = state.copyWith(
            selectedWord: WordSelection(
              section: (0, 0),
              wordId: '1',
            ),
          );
          expect(
            newState.selectedWord,
            WordSelection(
              section: (0, 0),
              wordId: '1',
            ),
          );
        });
      });

      group('WordSelection', () {
        test('can be instantiated', () {
          expect(
            WordSelection(
              section: (0, 0),
              wordId: '',
            ),
            isA<WordSelection>(),
          );
        });

        test('supports value comparisons', () {
          expect(
            WordSelection(
              section: (0, 0),
              wordId: '',
            ),
            WordSelection(
              section: (0, 0),
              wordId: '',
            ),
          );

          expect(
            WordSelection(
              section: (0, 0),
              wordId: '',
            ),
            isNot(
              WordSelection(
                section: (0, 0),
                wordId: '1',
              ),
            ),
          );
        });
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
