// ignore_for_file: prefer_const_constructors

import 'package:board_generator_playground/src/models/location.dart';
import 'package:test/test.dart';

void main() {
  group('$Location', () {
    group('left', () {
      test('returns a new location one unit to the left', () {
        final location = Location(x: 0, y: 0);
        expect(location.left(), Location(x: -1, y: 0));
      });

      test('returns a new location two units to the left', () {
        final location = Location(x: 0, y: 0);
        expect(location.left(2), Location(x: -2, y: 0));
      });
    });

    group('right', () {
      test('returns a new location one unit to the right', () {
        final location = Location(x: 0, y: 0);
        expect(location.right(), Location(x: 1, y: 0));
      });

      test('returns a new location two units to the right', () {
        final location = Location(x: 0, y: 0);
        expect(location.right(2), Location(x: 2, y: 0));
      });
    });

    group('up', () {
      test('returns a new location one unit above', () {
        final location = Location(x: 0, y: 0);
        expect(location.up(), Location(x: 0, y: -1));
      });

      test('returns a new location two units above', () {
        final location = Location(x: 0, y: 0);
        expect(location.up(2), Location(x: 0, y: -2));
      });
    });

    group('down', () {
      test('returns a new location one unit below', () {
        final location = Location(x: 0, y: 0);
        expect(location.down(), Location(x: 0, y: 1));
      });

      test('returns a new location two units below', () {
        final location = Location(x: 0, y: 0);
        expect(location.down(2), Location(x: 0, y: 2));
      });
    });

    group('shift', () {
      test('does nothing when no argument is specified', () {
        final location = Location(x: 0, y: 0);
        expect(location.shift(), Location(x: 0, y: 0));
      });

      test('returns a new location shifted by the given x and y values', () {
        final location = Location(x: 0, y: 0);
        expect(location.shift(x: 1, y: 1), Location(x: 1, y: 1));
      });
    });

    group('to', () {
      test('returns a set of locations between the two locations', () {
        final location = Location(x: 0, y: 0);
        expect(location.to(Location(x: 1, y: 1)), {
          Location(x: 0, y: 0),
          Location(x: 0, y: 1),
          Location(x: 1, y: 0),
          Location(x: 1, y: 1),
        });
      });

      test(
        'returns a set of locations between the two horizontal locations',
        () {
          final location = Location(x: 0, y: 0);
          expect(location.to(Location(x: 0, y: 2)), {
            Location(x: 0, y: 0),
            Location(x: 0, y: 1),
            Location(x: 0, y: 2),
          });
        },
      );

      test(
        'returns a set of locations between the two vertical locations',
        () {
          final location = Location(x: 0, y: 0);
          expect(location.to(Location(x: 2, y: 0)), {
            Location(x: 0, y: 0),
            Location(x: 1, y: 0),
            Location(x: 2, y: 0),
          });
        },
      );
    });

    group('copyWith', () {
      test('returns a new location with the same values', () {
        final location = Location(x: 1, y: 1);
        expect(location.copyWith(), Location(x: 1, y: 1));
      });

      test('returns a new location with the updated x value', () {
        final location = Location(x: 1, y: 1);
        expect(location.copyWith(x: 2), Location(x: 2, y: 1));
      });

      test('returns a new location with the updated y value', () {
        final location = Location(x: 1, y: 1);
        expect(location.copyWith(y: 2), Location(x: 1, y: 2));
      });
    });
  });
}
