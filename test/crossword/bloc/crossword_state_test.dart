// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

class _FakeWord extends Fake implements Word {
  _FakeWord({this.answer = ''});

  @override
  final String answer;

  @override
  int? get solvedTimestamp => 1;
}

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
      final fakeWord = _FakeWord();

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
                    solvedTimestamp: null,
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
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
              ),
            },
          );
          expect(state.copyWith(), state);
        });

        test('returns an instance with new sectionSize', () {
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

        test('returns an instance with new sections', () {
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
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
              ),
            },
          );
        });

        test('returns an instance with new mascot', () {
          final state = CrosswordLoaded(
            sectionSize: 400,
          );
          final newState = state.copyWith(mascot: Mascots.dino);
          expect(newState.mascot, equals(Mascots.dino));
        });

        test('returns an instance with new initials', () {
          final state = CrosswordLoaded(
            sectionSize: 400,
          );
          final newState = state.copyWith(initials: 'GIO');
          expect(newState.initials, equals('GIO'));
        });

        test('returns an instance with new selected word', () {
          final state = CrosswordLoaded(
            sectionSize: 400,
          );
          final newState = state.copyWith(
            selectedWord: WordSelection(
              section: (0, 0),
              word: fakeWord,
            ),
          );
          expect(
            newState.selectedWord,
            WordSelection(
              section: (0, 0),
              word: fakeWord,
            ),
          );
        });
      });

      group('WordSelection', () {
        test('can be instantiated', () {
          expect(
            WordSelection(
              section: (0, 0),
              word: fakeWord,
            ),
            isA<WordSelection>(),
          );
        });

        test('copyWith returns same object', () {
          final wordSelection = WordSelection(
            section: (0, 0),
            word: fakeWord,
          );
          expect(
            wordSelection.copyWith(),
            equals(wordSelection),
          );
        });

        test('copyWith updates solvedStatus', () {
          final wordSelection = WordSelection(
            section: (0, 0),
            word: fakeWord,
          );
          final solvedWordSelection = WordSelection(
            section: (0, 0),
            word: fakeWord,
            solvedStatus: WordStatus.solved,
          );
          expect(
            wordSelection.copyWith(solvedStatus: WordStatus.solved),
            equals(solvedWordSelection),
          );
        });

        test('supports value comparisons', () {
          expect(
            WordSelection(
              section: (0, 0),
              word: fakeWord,
            ),
            equals(
              WordSelection(
                section: (0, 0),
                word: fakeWord,
              ),
            ),
          );

          expect(
            WordSelection(
              section: (0, 0),
              word: _FakeWord(answer: 'flutter'),
            ),
            isNot(
              equals(
                WordSelection(
                  section: (0, 0),
                  word: _FakeWord(answer: 'dart'),
                ),
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
