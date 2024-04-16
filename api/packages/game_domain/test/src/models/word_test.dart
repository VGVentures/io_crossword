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
        length: 4,
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
          'length': 4,
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
        'length': 4,
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
            length: 4,
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
        length: 4,
        clue: 'clue',
        solvedTimestamp: 0,
      );
      final secondWord = Word(
        id: '1',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        length: 4,
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
        length: 4,
        clue: 'clue',
        solvedTimestamp: 0,
      );
      expect(firstWord, equals(firstWord.copyWith()));
    });
  });
}
