// ignore_for_file: prefer_const_constructors

import 'package:board_generator/create_sections.dart';
import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('WordExtension', () {
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
