// ignore_for_file: prefer_const_constructors

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:test/test.dart';

/// {@template test_crossword}
/// A pre-defined crossword for testing.
///
/// ```
///    -2 -1  0  1  2
/// -2  A  L  B  U  S
/// -1  -  -  E  -  -
///  0  -  -  H  -  -
///  1  -  -  A  -  -
///  2  -  -  N  -  -
/// ```
/// {@endtemplate}
class _TestCrossword extends Crossword {
  /// {@macro test_crossword}
  _TestCrossword() {
    add(
      WordEntry(
        word: 'behan',
        location: Location(x: 0, y: -2),
        direction: Direction.down,
      ),
    );
    add(
      WordEntry(
        word: 'albus',
        location: Location(x: -2, y: -2),
        direction: Direction.across,
      ),
    );
  }
}

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
        final board = _TestCrossword();

        const sun = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.isConnected(sun), isTrue);
      });

      test('not connected to the board in the position (2, -1) with s', () {
        final board = _TestCrossword();

        const sun = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -1),
          direction: Direction.down,
        );

        expect(board.isConnected(sun), isFalse);
      });

      test('connected to the board in the position (0, 0) with h', () {
        final board = _TestCrossword();

        const hat = WordEntry(
          word: 'hat',
          location: Location(x: 0, y: 0),
          direction: Direction.across,
        );

        expect(board.isConnected(hat), isTrue);
      });
    });

    group('connections', () {
      test('gets 4 connections for usa down at (1, -2)', () {
        final board = _TestCrossword();

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
        final board = _TestCrossword();

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
        final board = _TestCrossword();

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
        final board = _TestCrossword();

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
        final board = _TestCrossword();

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
        final board = _TestCrossword();

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
  });
}
