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
              wordEntry: const {url},
            ),
            Location(x: 0, y: 0): CharacterData(
              character: 'r',
              wordEntry: const {url},
            ),
            Location(x: 0, y: 1): CharacterData(
              character: 'l',
              wordEntry: const {url},
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
              wordEntry: const {url},
            ),
            Location(x: 0, y: 0): CharacterData(
              character: 'r',
              wordEntry: const {url},
            ),
            Location(x: 1, y: 0): CharacterData(
              character: 'l',
              wordEntry: const {url},
            ),
          },
        );
      });
    });

    group('isConnected', () {
      test('connected to the board in the position (2, -2) with s', () {
        final board = _TestCrossword();

        const sunWordEntry = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.isConnected(sunWordEntry), isTrue);
      });

      test('not connected to the board in the position (2, -1) with s', () {
        final board = _TestCrossword();

        const sunWordEntry = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -1),
          direction: Direction.down,
        );

        expect(board.isConnected(sunWordEntry), isFalse);
      });

      test('connected to the board in the position (0, 0) with h', () {
        final board = _TestCrossword();

        const sunWordEntry = WordEntry(
          word: 'hat',
          location: Location(x: 0, y: 0),
          direction: Direction.across,
        );

        expect(board.isConnected(sunWordEntry), isTrue);
      });
    });

    group('connections', () {
      test('gets 4 connections for usa at (1, -2)', () {
        final board = _TestCrossword();

        const sunWordEntry = WordEntry(
          word: 'usa',
          location: Location(x: 1, y: -2),
          direction: Direction.down,
        );

        expect(
          board.connections(sunWordEntry),
          <Location>{
            Location(x: 2, y: -2),
            Location(x: 0, y: -2),
            Location(x: 0, y: -1),
            Location(x: 0, y: 0),
          },
        );
      });
    });
  });
}
