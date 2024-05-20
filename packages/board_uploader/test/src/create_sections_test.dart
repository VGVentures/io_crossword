// ignore_for_file: prefer_const_constructors

import 'package:board_uploader/upload_board.dart';
import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('WordExtension', () {
    group('getSections', () {
      group('horizontal', () {
        test('finds only the first section starting on 0, 0', () {
          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(0, 0, 5),
            equals([Point(0, 0)]),
          );
        });

        test(
            'finds two sections with just by one character on the next section',
            () {
          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(0, 0, 4),
            equals([Point(0, 0), Point(1, 0)]),
          );
        });

        test('finds three sections of small size starting on 0, 0', () {
          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(0, 0, 2),
            equals([Point(0, 0), Point(1, 0), Point(2, 0)]),
          );
        });

        test('finds two sections of small size starting on section 25, 0', () {
          final word = Word(
            id: 'id',
            position: Point(100, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(100, 0, 4),
            equals([Point(25, 0), Point(26, 0)]),
          );
        });
      });

      group('vertical', () {
        test('finds only the first section starting on 0, 0', () {
          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(0, 0, 5),
            equals([Point(0, 0)]),
          );
        });

        test(
            'finds two sections with just by one character on the next section',
            () {
          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(0, 0, 4),
            equals([Point(0, 0), Point(0, 1)]),
          );
        });

        test('finds three sections of small size starting on 0, 0', () {
          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(0, 0, 2),
            equals([Point(0, 0), Point(0, 1), Point(0, 2)]),
          );
        });

        test('finds two sections of small size starting on section 25, 0', () {
          final word = Word(
            id: 'id',
            position: Point(0, 100),
            axis: Axis.vertical,
            clue: '',
            answer: 'HELLO',
          );

          expect(
            word.getSections(0, 100, 4),
            equals([Point(0, 25), Point(0, 26)]),
          );
        });
      });
    });

    group('getCollision', () {
      group('vertical', () {
        test('finds the first character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HELLO',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HAPPY',
          );

          expect(word.getCollision(letters), equals((0, 'H')));
        });

        test('finds the second character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HAPPY',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(1, -1),
            axis: Axis.vertical,
            clue: '',
            answer: 'SAD',
          );

          expect(word.getCollision(letters), equals((1, 'A')));
        });

        test('finds the third character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HELLO',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(3, -2),
            axis: Axis.vertical,
            clue: '',
            answer: 'HALO',
          );

          expect(word.getCollision(letters), equals((2, 'L')));
        });

        test('finds the fourth character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HELLO',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(4, -3),
            axis: Axis.vertical,
            clue: '',
            answer: 'HALO',
          );

          expect(word.getCollision(letters), equals((3, 'O')));
        });

        test(
          'does not find collision when the character '
          'is at the limit down',
          () {
            final letters = Word(
              id: 'id',
              position: Point(0, 0),
              axis: Axis.horizontal,
              clue: '',
              answer: 'HELLO',
            ).allLetters;

            final word = Word(
              id: 'id',
              position: Point(4, -4),
              axis: Axis.vertical,
              clue: '',
              answer: 'HALO',
            );

            expect(word.getCollision(letters), isNull);
          },
        );

        test(
          'does not find collision when the character '
          'is at the limit up',
          () {
            final letters = Word(
              id: 'id',
              position: Point(0, 0),
              axis: Axis.horizontal,
              clue: '',
              answer: 'HELLO',
            ).allLetters;

            final word = Word(
              id: 'id',
              position: Point(0, 1),
              axis: Axis.vertical,
              clue: '',
              answer: 'HALO',
            );

            expect(word.getCollision(letters), isNull);
          },
        );
      });

      group('horizontal', () {
        test('finds the first character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HELLO',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HAPPY',
          );

          expect(word.getCollision(letters), equals((0, 'H')));
        });

        test('finds the second character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HAPPY',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(-1, 1),
            axis: Axis.horizontal,
            clue: '',
            answer: 'SAD',
          );

          expect(word.getCollision(letters), equals((1, 'A')));
        });

        test('finds the third character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HELLO',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(-2, 2),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HALO',
          );

          expect(word.getCollision(letters), equals((2, 'L')));
        });

        test('finds the fourth character position', () {
          final letters = Word(
            id: 'id',
            position: Point(0, 0),
            axis: Axis.vertical,
            clue: '',
            answer: 'HELLO',
          ).allLetters;

          final word = Word(
            id: 'id',
            position: Point(-3, 3),
            axis: Axis.horizontal,
            clue: '',
            answer: 'HALO',
          );

          expect(word.getCollision(letters), equals((3, 'O')));
        });

        test(
          'does not find collision when the character '
          'is at the limit left',
          () {
            final letters = Word(
              id: 'id',
              position: Point(0, 0),
              axis: Axis.vertical,
              clue: '',
              answer: 'HELLO',
            ).allLetters;

            final word = Word(
              id: 'id',
              position: Point(-4, 3),
              axis: Axis.horizontal,
              clue: '',
              answer: 'HALO',
            );

            expect(word.getCollision(letters), isNull);
          },
        );

        test(
          'does not find collision when the character '
          'is at the limit left',
          () {
            final letters = Word(
              id: 'id',
              position: Point(0, 0),
              axis: Axis.vertical,
              clue: '',
              answer: 'HELLO',
            ).allLetters;

            final word = Word(
              id: 'id',
              position: Point(1, 0),
              axis: Axis.horizontal,
              clue: '',
              answer: 'HALO',
            );

            expect(word.getCollision(letters), isNull);
          },
        );
      });
    });
  });
}
