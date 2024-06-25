// ignore_for_file: prefer_const_constructors

import 'package:board_generator/board_generator.dart';
import 'package:test/test.dart';

void main() {
  group('$HorizontalLineOfSymmetry', () {
    group('isAbove', () {
      test('returns true when vertical position is above', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isAbove(-1), isTrue);
      });

      test('returns false when vertical position is below', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isAbove(1), isFalse);
      });

      test('returns false when vertical position is on', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isAbove(0), isFalse);
      });
    });

    group('isBelow', () {
      test('returns false when vertical position is above', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isBelow(-1), isFalse);
      });

      test('returns true when vertical position is below', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isBelow(1), isTrue);
      });

      test('returns false when vertical position is on', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isBelow(0), isFalse);
      });
    });

    group('isOn', () {
      test('returns false when vertical position is above', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isOn(-1), isFalse);
      });

      test('returns false when vertical position is below', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isOn(1), isFalse);
      });

      test('returns true when vertical position is on', () {
        final line = HorizontalLineOfSymmetry();
        expect(line.isOn(0), isTrue);
      });
    });

    group('mirror', () {
      group('when going across', () {
        test('and below the line', () {
          final line = HorizontalLineOfSymmetry();
          final entry = WordEntry(
            word: 'SOS',
            start: Location(x: 0, y: 3),
            direction: Direction.across,
          );

          final mirrored = line.mirror(entry);
          expect(mirrored, Location(x: 0, y: -3));
        });

        test('and above the line', () {
          final line = HorizontalLineOfSymmetry();
          final entry = WordEntry(
            word: 'SOS',
            start: Location(x: 0, y: -3),
            direction: Direction.across,
          );

          final mirrored = line.mirror(entry);
          expect(mirrored, Location(x: 0, y: 3));
        });
      });

      group('when going down', () {
        test('and below the line', () {
          final line = HorizontalLineOfSymmetry();
          final entry = WordEntry(
            word: 'YES',
            start: Location(x: 0, y: 1),
            direction: Direction.down,
          );

          final mirrored = line.mirror(entry);
          expect(mirrored, Location(x: 0, y: -3));
        });

        test('and above the line', () {
          final line = HorizontalLineOfSymmetry();
          final entry = WordEntry(
            word: 'YES',
            start: Location(x: 0, y: -3),
            direction: Direction.down,
          );

          final mirrored = line.mirror(entry);
          expect(mirrored, Location(x: 0, y: 1));
        });
      });
    });
  });
}
