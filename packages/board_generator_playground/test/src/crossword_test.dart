// ignore_for_file: prefer_const_constructors

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:test/test.dart';

import 'fixtures/crosswords.dart';

void main() {
  group('$Crossword', () {
    group('add', () {
      test('adds a down word to the character map', () {
        final board = Crossword();

        const url = WordEntry(
          word: 'url',
          location: Location(x: 0, y: -1),
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

        const url = WordEntry(
          word: 'url',
          location: Location(x: -1, y: 0),
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
          location: Location(x: 0, y: -2),
          direction: Direction.down,
        );
        final albus = WordEntry(
          word: 'albus',
          location: Location(x: -2, y: -2),
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
                    location: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                  WordEntry(
                    word: 'albus',
                    location: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: 0, y: -1): CharacterData(
                character: 'e',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    location: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: 0, y: 0): CharacterData(
                character: 'h',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    location: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: 0, y: 1): CharacterData(
                character: 'a',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    location: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: 0, y: 2): CharacterData(
                character: 'n',
                wordEntry: {
                  WordEntry(
                    word: 'behan',
                    location: Location(x: 0, y: -2),
                    direction: Direction.down,
                  ),
                },
              ),
              Location(x: -2, y: -2): CharacterData(
                character: 'a',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    location: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: -1, y: -2): CharacterData(
                character: 'l',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    location: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: 1, y: -2): CharacterData(
                character: 'u',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    location: Location(x: -2, y: -2),
                    direction: Direction.across,
                  ),
                },
              ),
              Location(x: 2, y: -2): CharacterData(
                character: 's',
                wordEntry: {
                  WordEntry(
                    word: 'albus',
                    location: Location(x: -2, y: -2),
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

        const sun = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.isConnected(sun), isTrue);
      });

      test('not connected to the board in the position (2, -1) with s', () {
        final board = Crossword1();

        const sun = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -1),
          direction: Direction.down,
        );

        expect(board.isConnected(sun), isFalse);
      });

      test('connected to the board in the position (0, 0) with h', () {
        final board = Crossword1();

        const hat = WordEntry(
          word: 'hat',
          location: Location(x: 0, y: 0),
          direction: Direction.across,
        );

        expect(board.isConnected(hat), isTrue);
      });
    });

    group('overrides', () {
      test('returns false when complete empty spot', () {
        final board = Crossword1();

        const word = WordEntry(
          word: 'egg',
          location: Location(x: 1, y: -1),
          direction: Direction.across,
        );

        expect(board.overrides(word), isFalse);
      });
    });

    group('overlaps', () {
      test('returns true when complete empty spot', () {
        final board = Crossword3();

        const word = WordEntry(
          word: 'sandy',
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.overlaps(word), isTrue);
      });

      test('returns true when overlaps horizontal', () {
        final board = Crossword4();

        const word = WordEntry(
          word: 'sand',
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.overlaps(word), isTrue);
      });

      test('returns true when complete empty spot', () {
        final board = Crossword3();

        const word = WordEntry(
          word: 'sandy',
          location: Location(x: 2, y: -1),
          direction: Direction.down,
        );

        expect(board.overlaps(word), isTrue);
      });
    });

    group('connections', () {
      test('gets 4 connections for usa down at (1, -2)', () {
        final board = Crossword1();

        const usa = WordEntry(
          word: 'usa',
          location: Location(x: 1, y: -2),
          direction: Direction.down,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 2, y: -2),
            Location(x: 0, y: -2),
            Location(x: 0, y: -1),
            Location(x: 0, y: 0),
          },
        );
      });

      test('gets 1 connections for usa down at (2, -2)', () {
        final board = Crossword1();

        const usa = WordEntry(
          word: 'sand',
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 1, y: -2),
          },
        );
      });

      test('gets 3 connections for usa down at (2, -2)', () {
        final board = Crossword1();

        const usa = WordEntry(
          word: 'sa',
          location: Location(x: 1, y: -1),
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

      test('gets 2 connections for across down at (-1, 1)', () {
        final board = Crossword1();

        const usa = WordEntry(
          word: 'usa',
          location: Location(x: -2, y: 1),
          direction: Direction.across,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 0, y: 0),
            Location(x: 0, y: 2),
          },
        );
      });

      test('gets 1 connections for sand across at (2, -2)', () {
        final board = Crossword1();

        const usa = WordEntry(
          word: 'sand',
          location: Location(x: 2, y: -2),
          direction: Direction.across,
        );

        expect(
          board.connections(usa),
          <Location>{
            Location(x: 1, y: -2),
          },
        );
      });

      test('gets 3 connections for usa across at (2, -2)', () {
        final board = Crossword1();

        const usa = WordEntry(
          word: 'egg',
          location: Location(x: 1, y: -1),
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
              maximumLength: Crossword.largestWordLength,
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
              maximumLength: Crossword.largestWordLength,
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
              maximumLength: 3,
              location: candidate.location,
              direction: candidate.direction,
              constraints: const {0: 's', 4: 'w'},
            ),
          ),
        );
      });
    });
  });
}
