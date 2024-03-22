import 'package:board_generator_playground/src/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('$WordCandidate', () {
    group('satisfies', () {
      group('returns true', () {
        test('when there is no constraint', () {
          const candidate = ConstrainedWordCandidate(
            invalidLengths: {},
            location: Location.zero,
            direction: Direction.across,
            constraints: {},
          );

          expect(candidate.satisfies('abc'), isTrue);
        });

        test('when it satisfies the invalid length constraint', () {
          const candidate = ConstrainedWordCandidate(
            invalidLengths: {1, 2, 4, 5, 6, 7},
            location: Location.zero,
            direction: Direction.across,
            constraints: {},
          );

          expect(candidate.satisfies('abc'), isTrue);
        });

        test('when it satisfies the character constraints', () {
          const candidate = ConstrainedWordCandidate(
            invalidLengths: {},
            location: Location.zero,
            direction: Direction.across,
            constraints: {0: 'a', 1: 'b', 3: 'c', 4: 'd', 5: 'e'},
          );

          expect(candidate.satisfies('abc'), isTrue);
        });

        test(
          'when it satisfies the character constraints with wrong casing',
          () {
            const candidate = ConstrainedWordCandidate(
              invalidLengths: {},
              location: Location.zero,
              direction: Direction.across,
              constraints: {0: 'A', 1: 'b', 3: 'C', 4: 'd', 5: 'E'},
            );

            expect(candidate.satisfies('aBc'), isTrue);
          },
        );

        test('when it satisfies all constraints', () {
          const candidate = ConstrainedWordCandidate(
            invalidLengths: {1, 2, 4, 5, 6, 7},
            location: Location.zero,
            direction: Direction.across,
            constraints: {0: 'a', 1: 'b', 3: 'c', 4: 'd', 5: 'e'},
          );

          expect(candidate.satisfies('abc'), isTrue);
        });
      });

      group('returns false', () {
        test('when the word has an invalid length', () {
          const candidate = ConstrainedWordCandidate(
            invalidLengths: {3},
            location: Location.zero,
            direction: Direction.across,
            constraints: {},
          );

          expect(candidate.satisfies('abc'), isFalse);
        });

        test('when the word has an invalid first character constraint', () {
          const candidate = ConstrainedWordCandidate(
            invalidLengths: {},
            location: Location.zero,
            direction: Direction.across,
            constraints: {0: 'd'},
          );

          expect(candidate.satisfies('abc'), isFalse);
        });

        test('when the word has an invalid last character constraint', () {
          const candidate = ConstrainedWordCandidate(
            invalidLengths: {},
            location: Location.zero,
            direction: Direction.across,
            constraints: {2: 'd'},
          );

          expect(candidate.satisfies('abc'), isFalse);
        });
      });
    });
  });
}
