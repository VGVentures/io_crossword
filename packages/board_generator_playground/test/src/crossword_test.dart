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
      group('isFalse', () {
        group('when going down', () {
          test(
            'when it gracefully overrides horizontally its end',
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
        });

        group('when going across', () {
          test(
            'when it gracefully overrides horizontally its end',
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
            'when it gracefully overrides horizontally its start',
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
      });

      group('isTrue', () {
        group('when going down', () {
          test('and partially overrides horizontally its start', () {
            final board = Crossword1();

            final word = WordEntry(
              word: 'candy',
              start: Location(x: 2, y: -2),
              direction: Direction.down,
            );

            expect(board.overlaps(word), isTrue);
          });

          test(
            'and partially overriding horizontally its end',
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

          test('and overlapping horizontally without overriding', () {
            final board = Crossword4();

            final word = WordEntry(
              word: 'sand',
              start: Location(x: 2, y: -2),
              direction: Direction.down,
            );

            expect(board.overlaps(word), isTrue);
          });

          test('and overlapping and overriding horizontally', () {
            final board = Crossword3();

            final word = WordEntry(
              word: 'sandy',
              start: Location(x: 2, y: -1),
              direction: Direction.down,
            );

            expect(board.overlaps(word), isTrue);
          });

          test('and overlapping horizontally its prefix without overriding',
              () {
            final board = Crossword1();

            final word = WordEntry(
              word: 'sandy',
              start: Location(x: 2, y: -1),
              direction: Direction.down,
            );

            expect(board.overlaps(word), isTrue);
          });
        });

        group('when going across', () {
          test(
            'and partially overriding horizontally its start',
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
            'and partially overriding horizontally its end',
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
            '''and overlapping horizontally its suffix without overriding''',
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
            '''and overlapping horizontally its end and partially overriding horizontally gracefully''',
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
            'and partially overlapping horizontally gracefully',
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
            '''and overlapping vertically without overriding''',
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
        });
      });
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
      group('returns null', () {
        test('when going down and neighboring word has matching direction', () {
          final board = Crossword1();

          final candidate = WordCandidate(
            location: Location(x: 1, y: -2),
            direction: Direction.down,
          );

          final constraints = board.constraints(candidate);
          expect(constraints, isNull);
        });

        test('when going across neighboring word has matching direction', () {
          final board = Crossword1();

          final candidate = WordCandidate(
            location: Location(x: 0, y: -1),
            direction: Direction.across,
          );

          final constraints = board.constraints(candidate);
          expect(constraints, isNull);
        });
      });

      group('derives', () {
        group('when bounded', () {
          test('down', () {
            final board = Crossword1(
              bounds: Bounds.fromTLBR(
                topLeft: Location(x: -2, y: -2),
                bottomRight: Location(x: 2, y: 2),
              ),
              largestWordLength: 8,
            );

            final candidate = WordCandidate(
              location: Location(x: -2, y: -2),
              direction: Direction.down,
            );

            final constraints = board.constraints(candidate);
            expect(
              constraints,
              equals(
                ConstrainedWordCandidate(
                  invalidLengths: const {6, 7, 8},
                  location: candidate.location,
                  direction: candidate.direction,
                  constraints: const {0: 'a'},
                ),
              ),
            );
          });

          test('across', () {
            final board = Crossword1(
              bounds: Bounds.fromTLBR(
                topLeft: Location(x: -2, y: -2),
                bottomRight: Location(x: 2, y: 2),
              ),
              largestWordLength: 8,
            );

            final candidate = WordCandidate(
              location: Location(x: -2, y: 0),
              direction: Direction.across,
            );

            final constraints = board.constraints(candidate);
            expect(
              constraints,
              equals(
                ConstrainedWordCandidate(
                  invalidLengths: const {2, 6, 7, 8},
                  location: candidate.location,
                  direction: candidate.direction,
                  constraints: const {2: 'h'},
                ),
              ),
            );
          });
        });

        group('when going across', () {
          test('a word in the same height', () {
            final board = Crossword7();

            final candidate = WordCandidate(
              location: Location(x: -1, y: 0),
              direction: Direction.across,
            );

            final constraints = board.constraints(candidate);
            expect(constraints, isNull);
          });

          test('from an unconnected location', () {
            final board = Crossword1();

            final candidate = WordCandidate(
              location: Location(x: -17, y: 0),
              direction: Direction.across,
            );

            final constraints = board.constraints(candidate);
            expect(
              constraints,
              equals(
                ConstrainedWordCandidate(
                  invalidLengths: const {17},
                  location: candidate.location,
                  direction: candidate.direction,
                  constraints: const {17: 'h'},
                ),
              ),
            );
          });

          test('a single constraint across with no invalid lengths', () {
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

          test('two constraints with multiple invalid lengths', () {
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
                  invalidLengths: {
                    2,
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
                  constraints: const {0: 'e', 2: 'n'},
                ),
              ),
            );
          });
        });

        group('when going down', () {
          test('overlay of a word changing meaning after the 4 character', () {
            final board = Crossword6();

            final candidate = WordCandidate(
              location: Location(x: 8, y: -2),
              direction: Direction.down,
            );

            final constraints = board.constraints(candidate);
            expect(
              constraints,
              equals(
                ConstrainedWordCandidate(
                  invalidLengths:
                      List.generate(15, (index) => 4 + index).toSet(),
                  location: candidate.location,
                  direction: candidate.direction,
                  constraints: const {0: 'k'},
                ),
              ),
            );
          });

          test('a single constraint with a no invalid lengths', () {
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

          test('two constraints with a single invalid length', () {
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

          test('two constraints with multiple invalid lengths', () {
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
                  invalidLengths:
                      List.generate(16, (index) => 3 + index).toSet(),
                  location: candidate.location,
                  direction: candidate.direction,
                  constraints: const {0: 's'},
                ),
              ),
            );
          });
        });
      });
    });

    group('toPrettyString', () {
      test('returns a pretty string for the crossword', () {
        final board = Crossword1();

        final prettyString = board.toPrettyString();
        expect(
          prettyString,
          equals(
            'ALBUS\n'
            '--E--\n'
            '--H--\n'
            '--A--\n'
            '--N--\n',
          ),
        );
      });
    });
  });
}
