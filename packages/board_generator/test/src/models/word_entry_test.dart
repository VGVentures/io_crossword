// ignore_for_file: prefer_const_constructors

import 'package:board_generator/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('$WordEntry', () {
    test('end is as expected', () {
      // ```
      //    -2 -1  0  1  2
      // -3  -  *  *  *  -
      // -2  *  B  U  S  *
      // -1  -  *  *  *  -
      // ```
      final entry = WordEntry(
        word: 'BUS',
        start: Location(x: -1, y: -2),
        direction: Direction.across,
      );

      expect(entry.end, Location(x: 1, y: -2));
    });

    group('prefix', () {
      test('is correct when across', () {
        final entry = WordEntry(
          word: 'BUS',
          start: Location(x: 0, y: 0),
          direction: Direction.across,
        );

        expect(entry.prefix, Location(x: -1, y: 0));
      });

      test('is correct when down', () {
        final entry = WordEntry(
          word: 'BUS',
          start: Location(x: 0, y: 0),
          direction: Direction.down,
        );

        expect(entry.prefix, Location(x: 0, y: -1));
      });
    });

    group('suffix', () {
      test('is correct when across', () {
        final entry = WordEntry(
          word: 'BUS',
          start: Location(x: 0, y: 0),
          direction: Direction.across,
        );

        expect(entry.suffix, Location(x: 3, y: 0));
      });

      test('is correct when down', () {
        final entry = WordEntry(
          word: 'BUS',
          start: Location(x: 0, y: 0),
          direction: Direction.down,
        );

        expect(entry.suffix, Location(x: 0, y: 3));
      });
    });

    group('surroundings', () {
      test('returns as expected when across', () {
        // ```
        //    -2 -1  0  1  2
        // -3  -  *  *  *  -
        // -2  *  B  U  S  *
        // -1  -  *  *  *  -
        // ```
        final entry = WordEntry(
          word: 'BUS',
          start: Location(x: -1, y: -2),
          direction: Direction.across,
        );

        final surroundings = entry.surroundings();
        expect(
          surroundings,
          equals({
            Location(x: -2, y: -2),
            Location(x: -1, y: -1),
            Location(x: 0, y: -1),
            Location(x: 1, y: -1),
            Location(x: 2, y: -2),
            Location(x: 1, y: -3),
            Location(x: 0, y: -3),
            Location(x: -1, y: -3),
          }),
        );
      });

      test('returns as expected when down', () {
        // ```
        //    -2 -1  0
        // -3  -  *  -
        // -2  *  B  *
        // -1  *  U  *
        //  0  *  S  *
        //  1  -  *  -
        // ```
        final entry = WordEntry(
          word: 'BUS',
          start: Location(x: -1, y: -2),
          direction: Direction.down,
        );

        final surroundings = entry.surroundings();
        expect(
          surroundings,
          equals({
            Location(x: -1, y: -3),
            Location(x: -2, y: -2),
            Location(x: -2, y: -1),
            Location(x: -2, y: -0),
            Location(x: -1, y: 1),
            Location(x: 0, y: 0),
            Location(x: 0, y: -1),
            Location(x: 0, y: -2),
          }),
        );
      });
    });
  });
}
