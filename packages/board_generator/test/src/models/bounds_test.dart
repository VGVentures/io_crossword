// ignore_for_file: prefer_const_constructors

import 'package:board_generator/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('$Bounds', () {
    test('supports value equality', () {
      final bounds1 = Bounds.fromTLBR(
        topLeft: Location(x: -5, y: -5),
        bottomRight: Location(x: 5, y: 5),
      );
      final bounds2 = Bounds.fromTLBR(
        topLeft: Location(x: -5, y: -5),
        bottomRight: Location(x: 5, y: 5),
      );

      expect(bounds1, bounds2);
    });

    group('.square', () {
      test('derives correctly when size is even', () {
        final bounds = Bounds.square(size: 10);

        expect(bounds.topLeft, const Location(x: -5, y: -5));
        expect(bounds.bottomRight, const Location(x: 5, y: 5));
      });

      test('derives correctly when size is odd', () {
        final bounds = Bounds.square(size: 11);

        expect(bounds.topLeft, const Location(x: -5, y: -5));
        expect(bounds.bottomRight, const Location(x: 5, y: 5));
      });
    });

    test('width is correct', () {
      const bounds = Bounds.fromTLBR(
        topLeft: Location(x: -5, y: 0),
        bottomRight: Location(x: 5, y: 0),
      );

      expect(bounds.width, 10);
    });

    test('height is correct', () {
      const bounds = Bounds.fromTLBR(
        topLeft: Location(x: 0, y: -5),
        bottomRight: Location(x: 0, y: 5),
      );

      expect(bounds.height, 10);
    });

    group('contains', () {
      group('returns true', () {
        test('when location is inside bounds', () {
          const bounds = Bounds.fromTLBR(
            topLeft: Location(x: -5, y: -5),
            bottomRight: Location(x: 5, y: 5),
          );

          expect(bounds.contains(const Location(x: 3, y: 3)), isTrue);
        });

        test('when location is at bounds border', () {
          const bounds = Bounds.fromTLBR(
            topLeft: Location(x: -5, y: -5),
            bottomRight: Location(x: 5, y: 5),
          );

          expect(bounds.contains(const Location(x: -5, y: -5)), isTrue);
          expect(bounds.contains(const Location(x: 5, y: 5)), isTrue);
        });
      });

      group('returns false', () {
        test('when location is outside bounds', () {
          const bounds = Bounds.fromTLBR(
            topLeft: Location(x: -5, y: -5),
            bottomRight: Location(x: 5, y: 5),
          );

          expect(bounds.contains(const Location(x: 6, y: 6)), isFalse);
        });
      });
    });
  });
}
