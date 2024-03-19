// ignore_for_file: prefer_const_constructors

import 'package:board_generator_playground/src/board.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('$Board', () {
    group('add', () {
      test('adds a down word to the character map', () {
        final board = Board();

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
        final board = Board();

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
  });
}
