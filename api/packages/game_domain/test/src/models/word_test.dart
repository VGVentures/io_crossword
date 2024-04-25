// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Word', () {
    test('creates correct json object from Word object', () {
      final word = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        solvedTimestamp: 0,
        mascot: Mascots.sparky,
      );
      final json = word.toJson();

      expect(
        json,
        equals({
          'id': '1',
          'position': {'x': 1, 'y': 2},
          'axis': 'horizontal',
          'answer': 'test',
          'clue': 'clue',
          'solvedTimestamp': 0,
          'mascot': 'sparky',
        }),
      );
    });

    test('creates correct Word object from json object', () {
      final json = {
        'id': 'id',
        'position': {'x': 1, 'y': 2},
        'axis': 'horizontal',
        'mascot': 'sparky',
        'answer': 'test',
        'clue': 'clue',
      };
      final word = Word.fromJson(json);
      expect(
        word,
        equals(
          Word(
            id: 'id',
            position: Point(1, 2),
            axis: Axis.horizontal,
            answer: 'test',
            clue: 'clue',
            mascot: Mascots.sparky,
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstWord = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        solvedTimestamp: 0,
      );
      final secondWord = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        solvedTimestamp: 0,
      );

      expect(firstWord, equals(secondWord));
    });

    test('supports equality', () {
      final firstWord = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        solvedTimestamp: 0,
      );
      final secondWord = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        solvedTimestamp: 0,
      );

      expect(firstWord, equals(secondWord));
    });

    test('supports copy', () {
      final firstWord = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        solvedTimestamp: 0,
      );
      expect(firstWord, equals(firstWord.copyWith()));
    });

    test('returns the length of the answer', () {
      final word = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
      );

      expect(
        word.length,
        equals(4),
      );

      expect(
        word.copyWith(answer: 'testing').length,
        equals(7),
      );

      expect(
        word.copyWith(answer: '   ').length,
        equals(3),
      );
    });

    group('isSolved', () {
      test(' true', () {
        final word = Word(
          id: '1',
          position: Point(1, 2),
          axis: Axis.horizontal,
          answer: 'test',
          clue: 'clue',
          solvedTimestamp: 1234,
        );

        expect(word.isSolved, isTrue);
      });

      test(' false', () {
        final word = Word(
          id: '1',
          position: Point(1, 2),
          axis: Axis.horizontal,
          answer: '',
          clue: 'clue',
        );

        expect(word.isSolved, isFalse);
      });
    });
  });
}
