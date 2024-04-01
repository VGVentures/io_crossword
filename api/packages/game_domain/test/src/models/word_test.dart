// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Word', () {
    test('creates correct json object from Word object', () {
      final word = Word(
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        hints: const ['hint'],
        solvedTimestamp: 0,
        mascot: Mascots.sparky,
      );
      final json = word.toJson();

      expect(
        json,
        equals({
          'position': {'x': 1, 'y': 2},
          'axis': 'horizontal',
          'answer': 'test',
          'clue': 'clue',
          'hints': ['hint'],
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
        'hints': ['hint'],
      };
      final word = Word.fromJson(json);
      expect(
        word,
        equals(
          Word(
            position: Point(1, 2),
            axis: Axis.horizontal,
            answer: 'test',
            clue: 'clue',
            hints: const ['hint'],
            solvedTimestamp: null,
            mascot: Mascots.sparky,
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstWord = Word(
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        hints: const ['hint'],
        solvedTimestamp: 0,
      );
      final secondWord = Word(
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        hints: const ['hint'],
        solvedTimestamp: 0,
      );

      expect(firstWord, equals(secondWord));
    });

    test('supports copy', () {
      final firstWord = Word(
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        hints: const ['hint'],
        solvedTimestamp: 0,
      );
      expect(firstWord, equals(firstWord.copyWith()));
    });
  });
}
