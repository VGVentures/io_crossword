// ignore_for_file: prefer_const_constructors

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('$Crossword', () {
    /// A L B U S
    /// - - E - -
    /// - - H (0, 0)
    /// - - A - -
    /// - - N - -
    final characterMap = {
      Location(x: 0, y: -2): 'b',
      Location(x: 0, y: -1): 'e',
      Location(x: 0, y: 0): 'h',
      Location(x: 0, y: 1): 'a',
      Location(x: 0, y: 2): 'n',
      Location(x: -2, y: -2): 'a',
      Location(x: -1, y: -2): 'l',
      Location(x: 1, y: -2): 'u',
      Location(x: 2, y: -2): 's',
    };

    group('add', () {
      test('adds a down word to the character map', () {
        final board = Crossword();

        const urlWordEntry = WordEntry(
          word: 'url',
          location: Location(x: 0, y: -1),
          direction: Direction.down,
        );
        board.add(urlWordEntry);

        expect(
          board.characterMap,
          {
            Location(x: 0, y: -1): 'u',
            Location(x: 0, y: 0): 'r',
            Location(x: 0, y: 1): 'l',
          },
        );
      });

      test('adds an across word to the character map', () {
        final board = Crossword();

        const urlWordEntry = WordEntry(
          word: 'url',
          location: Location(x: -1, y: 0),
          direction: Direction.across,
        );
        board.add(urlWordEntry);

        expect(
          board.characterMap,
          {
            Location(x: -1, y: 0): 'u',
            Location(x: 0, y: 0): 'r',
            Location(x: 1, y: 0): 'l',
          },
        );
      });
    });

    group('isConnected', () {
      test('connected to the board in the position (2, -2) with s', () {
        final board = Crossword()..characterMap.addAll(characterMap);

        const sunWordEntry = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -2),
          direction: Direction.down,
        );

        expect(board.isConnected(sunWordEntry), isTrue);
      });

      test('not connected to the board in the position (2, -1) with s', () {
        final board = Crossword()..characterMap.addAll(characterMap);

        const sunWordEntry = WordEntry(
          word: 'sun',
          location: Location(x: 2, y: -1),
          direction: Direction.down,
        );

        expect(board.isConnected(sunWordEntry), isFalse);
      });

      test('connected to the board in the position (0, 0) with h', () {
        final board = Crossword()..characterMap.addAll(characterMap);

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
        final board = Crossword()..characterMap.addAll(characterMap);

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
