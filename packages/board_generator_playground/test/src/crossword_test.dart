// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:test/test.dart';

import 'fixtures/crosswords.dart';

void main() {
  group('$Crossword', () {
    group('add', () {
      test('adds a down word to the character map', () {
        final board = Crossword();

        final url = WordEntry(
          word: 'url',
          start: Location(x: 0, y: -1),
          direction: Direction.down,
        );
        board.add(url);

        expect(
          board.characterMap,
          {
            Location(x: 0, y: -1): CharacterData(
              character: 'u',
              wordEntry: {url},
            ),
            Location(x: 0, y: 0): CharacterData(
              character: 'r',
              wordEntry: {url},
            ),
            Location(x: 0, y: 1): CharacterData(
              character: 'l',
              wordEntry: {url},
            ),
          },
        );
      });

      test('adds an across word to the character map', () {
        final board = Crossword();

        final url = WordEntry(
          word: 'url',
          start: Location(x: -1, y: 0),
          direction: Direction.across,
        );
        board.add(url);

        expect(
          board.characterMap,
          {
            Location(x: -1, y: 0): CharacterData(
              character: 'u',
              wordEntry: {url},
            ),
            Location(x: 0, y: 0): CharacterData(
              character: 'r',
              wordEntry: {url},
            ),
            Location(x: 1, y: 0): CharacterData(
              character: 'l',
              wordEntry: {url},
            ),
          },
        );
      });

      test('adds crossing words', () {
        final behan = WordEntry(
          word: 'behan',
          start: Location(x: 0, y: -2),
          direction: Direction.down,
        );
        final albus = WordEntry(
          word: 'albus',
          start: Location(x: -2, y: -2),
          direction: Direction.across,
        );

        final board = Crossword()
          ..add(behan)
          ..add(albus);

        expect(
          board.characterMap,
          equals(
            {
              Location(x: 0, y: -2): CharacterData(
                character: 'b',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    start: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                  WordEntry(
                    word: 'albus',
                    start: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: 0, y: -1): CharacterData(
                character: 'e',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    start: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: 0, y: 0): CharacterData(
                character: 'h',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    start: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: 0, y: 1): CharacterData(
                character: 'a',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    start: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: 0, y: 2): CharacterData(
                character: 'n',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    start: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: -2, y: -2): CharacterData(
                character: 'a',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    start: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: -1, y: -2): CharacterData(
                character: 'l',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    start: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: 1, y: -2): CharacterData(
                character: 'u',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    start: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: 2, y: -2): CharacterData(
                character: 's',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    start: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
            },
          ),
        );
      });
    });

    group('isConnected', () {
      test('connected to the board in the position (2, -2) with s', () {
        final board = Crossword1();

        final sun = WordEntry(
          word: 'sun',
          start: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.isConnected(sun), isTrue);
      });

      test('not connected to the board in the position (2, -1) with s', () {
        final board = Crossword1();

        final sun = WordEntry(
          word: 'sun',
          start: Location(x: 2, y: -1),
          direction: Direction.down,
        );

        expect(board.isConnected(sun), isFalse);
      });

      test('connected to the board in the position (0, 0) with h', () {
        final board = Crossword1();

        final hat = WordEntry(
          word: 'hat',
          start: Location(x: 0, y: 0),
          direction: Direction.across,
        );

        expect(board.isConnected(hat), isTrue);
      });
    });

    group('overrides', () {
      group('isFalse', () {
        test('when it is disconnected', () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'egg',
            start: Location(x: 1, y: -1),
            direction: Direction.across,
          );

          expect(board.overrides(word), isFalse);
        });

        test(
          'when there is a partial graceful vertical override',
          () {
            final board = Crossword1();

            final word = WordEntry(
              word: 'cat',
              start: Location(x: -1, y: 1),
              direction: Direction.across,
            );

            expect(board.overrides(word), isFalse);
          },
        );

        test('when there is a partial graceful horizontal override', () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'say',
            start: Location(x: 2, y: -2),
            direction: Direction.down,
          );

          expect(board.overrides(word), isFalse);
        });
      });

      group('isTrue', () {
        group('when going across', () {
          test('and there is an total horizontal graceful override', () {
            final board = Crossword2();

            final word = WordEntry(
              word: 'know',
              start: Location(x: -1, y: 2),
              direction: Direction.across,
            );

            expect(board.overrides(word), isTrue);
          });

          test('and there is an total horizontal ungraceful override', () {
            final board = Crossword2();

            final word = WordEntry(
              word: 'knew',
              start: Location(x: -1, y: 2),
              direction: Direction.across,
            );

            expect(board.overrides(word), isTrue);
          });

          test('and there is a partial horizontal ungraceful override', () {
            final board = Crossword2();

            final word = WordEntry(
              word: 'new',
              start: Location(x: 1, y: 2),
              direction: Direction.across,
            );

            expect(board.overrides(word), isTrue);
          });

          test('and there is an exact horizontal ungraceful override', () {
            final board = Crossword2();

            final word = WordEntry(
              word: 'new',
              start: Location(x: 0, y: 2),
              direction: Direction.across,
            );

            expect(board.overrides(word), isTrue);
          });

          test('and there is a partial vertical ungraceful override', () {
            final board = Crossword2();

            final word = WordEntry(
              word: 'bad',
              start: Location(x: -1, y: 0),
              direction: Direction.across,
            );

            expect(board.overrides(word), isTrue);
          });
        });

        group('when going down', () {
          test(
            '''and there is a partial horizontal ungraceful override''',
            () {
              final board = Crossword1();

              final word = WordEntry(
                word: 'buy',
                start: Location(x: 2, y: -2),
                direction: Direction.down,
              );

              expect(board.overrides(word), isTrue);
            },
          );

          test('and there is a partial vertical ungraceful override', () {
            final board = Crossword1();

            final word = WordEntry(
              word: 'buy',
              start: Location(x: 0, y: 2),
              direction: Direction.down,
            );

            expect(board.overrides(word), isTrue);
          });
        });
      });
    });

    group('overlaps', () {
      test('returns true because overriding first word with direction down',
          () {
        final board = Crossword1();

        final word = WordEntry(
          word: 'candy',
          start: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.overlaps(word), isTrue);
      });

      test('returns true when overlaps horizontal with direction down', () {
        final board = Crossword4();

        final word = WordEntry(
          word: 'sand',
          start: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.overlaps(word), isTrue);
      });

      test(
          'returns true when changes word across and last character '
          'with direction down', () {
        final board = Crossword3();

        final word = WordEntry(
          word: 'sandy',
          start: Location(x: 2, y: -1),
          direction: Direction.down,
        );

        expect(board.overlaps(word), isTrue);
      });

      test(
        'returns true when matches first character '
        'and does change word meaning with direction down',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'sandy',
            start: Location(x: 2, y: -1),
            direction: Direction.down,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns false when matches last character '
        'and does not change word meaning with direction down',
        () {
          final board = Crossword2();

          final word = WordEntry(
            word: 'cow',
            start: Location(x: 2, y: 0),
            direction: Direction.down,
          );

          expect(board.overlaps(word), isFalse);
        },
      );

      test(
        'returns true when does not match last character '
        'and changes the word with direction down',
        () {
          final board = Crossword2();

          final word = WordEntry(
            word: 'van',
            start: Location(x: 2, y: 0),
            direction: Direction.down,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns true when attaching to the right a word across '
        'and changes the word with direction across',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'usa',
            start: Location(x: -5, y: -2),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns true when attaching to the left a word across '
        'and changes the word with direction across',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'van',
            start: Location(x: -2, y: -2),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns true when attaching to the overriding a left a word across '
        'and changes the word with direction across',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'sand',
            start: Location(x: 2, y: -2),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns true when attaching to the same character at the right a word '
        'across and changes the word with direction across',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'usa',
            start: Location(x: -4, y: -2),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns true when attaching to character at the right a word '
        'going down and changes the word with direction across',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'usa',
            start: Location(x: -2, y: 0),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns true when adding a word at the end of a word '
        'going down and changes the word with direction across',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'usa',
            start: Location(x: -1, y: 3),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isTrue);
        },
      );

      test(
        'returns false when attaching to character at the right a word is '
        'the same going down and does not change the word with direction down',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'usa',
            start: Location(x: -2, y: 1),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isFalse);
        },
      );

      test(
        'returns false when attaching to character at the left a word is '
        'the same going down and does not change the word with direction down',
        () {
          final board = Crossword1();

          final word = WordEntry(
            word: 'add',
            start: Location(x: 0, y: 1),
            direction: Direction.across,
          );

          expect(board.overlaps(word), isFalse);
        },
      );
    });

    group('connections', () {
      test('gets 5 connections for usa down at (1, -2)', () {
        final board = Crossword1();

        final usa = WordEntry(
          word: 'usa',
          start: Location(x: 1, y: -2),
          direction: Direction.down,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 2, y: -2),
            Location(x: 1, y: -2),
            Location(x: 0, y: -2),
            Location(x: 0, y: -1),
            Location(x: 0, y: 0),
          },
        );
      });

      test('gets 2 connections for usa down at (2, -2)', () {
        final board = Crossword1();

        final usa = WordEntry(
          word: 'sand',
          start: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 2, y: -2),
            Location(x: 1, y: -2),
          },
        );
      });

      test('gets 4 connections for usa down at (2, -2)', () {
        final board = Crossword1();

        final usa = WordEntry(
          word: 'sa',
          start: Location(x: 1, y: -1),
          direction: Direction.down,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 1, y: -2),
            Location(x: 0, y: -1),
            Location(x: 0, y: 0),
          },
        );
      });

      test('gets 3 connections for across down at (-1, 1)', () {
        final board = Crossword1();

        final usa = WordEntry(
          word: 'usa',
          start: Location(x: -2, y: 1),
          direction: Direction.across,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 0, y: 0),
            Location(x: 0, y: 2),
            Location(x: 0, y: 1),
          },
        );
      });

      test('gets 2 connections for sand across at (2, -2)', () {
        final board = Crossword1();

        final usa = WordEntry(
          word: 'sand',
          start: Location(x: 2, y: -2),
          direction: Direction.across,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 2, y: -2),
            Location(x: 1, y: -2),
          },
        );
      });

      test('gets 3 connections for usa across at (2, -2)', () {
        final board = Crossword1();

        final usa = WordEntry(
          word: 'egg',
          start: Location(x: 1, y: -1),
          direction: Direction.across,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 1, y: -2),
            Location(x: 0, y: -1),
            Location(x: 2, y: -2),
          },
        );
      });
    });

    group('constraints', () {
      test('returns null if neighboring word has matching direction', () {
        final board = Crossword1();

        final candidate = WordCandidate(
          location: Location(x: 1, y: -2),
          direction: Direction.down,
        );

        final constraints = board.constraints(candidate);
        expect(constraints, isNull);
      });

      test('derives successfully a single constraint down', () {
        final board = Crossword1();

        final candidate = WordCandidate(
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        final constraints = board.constraints(candidate);
        expect(
          constraints,
          equals(
            ConstrainedWordCandidate(
              invalidLengths: const {},
              location: candidate.location,
              direction: candidate.direction,
              constraints: const {0: 's'},
            ),
          ),
        );
      });

      test('derives successfully two constraints down', () {
        final board = Crossword2();

        final candidate = WordCandidate(
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        final constraints = board.constraints(candidate);
        expect(
          constraints,
          equals(
            ConstrainedWordCandidate(
              invalidLengths: const {4},
              location: candidate.location,
              direction: candidate.direction,
              constraints: const {0: 's', 4: 'w'},
            ),
          ),
        );
      });

      test('derives successfully two constraints down with capped length', () {
        final board = Crossword3();

        final candidate = WordCandidate(
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        final constraints = board.constraints(candidate);
        expect(
          constraints,
          equals(
            ConstrainedWordCandidate(
              invalidLengths: const {3, 4},
              location: candidate.location,
              direction: candidate.direction,
              constraints: const {0: 's', 4: 'w'},
            ),
          ),
        );
      });

      test('returns null if neighboring word has matching direction across',
          () {
        final board = Crossword1();

        final candidate = WordCandidate(
          location: Location(x: 0, y: -1),
          direction: Direction.across,
        );

        final constraints = board.constraints(candidate);
        expect(constraints, isNull);
      });

      test('derives successfully a single constraint across', () {
        final board = Crossword1();

        final candidate = WordCandidate(
          location: Location(x: 0, y: 0),
          direction: Direction.across,
        );

        final constraints = board.constraints(candidate);
        expect(
          constraints,
          equals(
            ConstrainedWordCandidate(
              invalidLengths: const {},
              location: candidate.location,
              direction: candidate.direction,
              constraints: const {0: 'h'},
            ),
          ),
        );
      });

      test(
          'derives successfully two constraints across with invalid '
          'length at 2', () {
        final board = Crossword5();

        final candidate = WordCandidate(
          location: Location(x: -2, y: 2),
          direction: Direction.across,
        );

        final constraints = board.constraints(candidate);
        expect(
          constraints,
          equals(
            ConstrainedWordCandidate(
              invalidLengths: {2, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18},
              location: candidate.location,
              direction: candidate.direction,
              constraints: const {0: 'e', 2: 'n'},
            ),
          ),
        );
      });

      test('derives successfully two constraints across with capped length',
          () {
        final board = Crossword5();

        final candidate = WordCandidate(
          location: Location(x: -2, y: 1),
          direction: Direction.across,
        );

        final constraints = board.constraints(candidate);
        expect(
          constraints,
          equals(
            ConstrainedWordCandidate(
              invalidLengths: const {
                2,
                4,
                5,
                6,
                7,
                8,
                9,
                10,
                11,
                12,
                13,
                14,
                15,
                16,
                17,
                18,
              },
              location: candidate.location,
              direction: candidate.direction,
              constraints: const {0: 'l', 2: 'a'},
            ),
          ),
        );
      });
    });
  });
}
