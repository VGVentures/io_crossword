// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Word', () {
    test('creates correct json object from Word object', () {
      final word = Word(
        id: 'id',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        hints: const ['hint'],
        visible: true,
        solvedTimestamp: 0,
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
          'visible': true,
          'solvedTimestamp': 0,
        }),
      );
    });

    test('creates correct Word object from json object', () {
      final json = {
        'id': 'id',
        'position': {'x': 1, 'y': 2},
        'axis': 'horizontal',
        'answer': 'test',
        'clue': 'clue',
        'hints': ['hint'],
        'visible': true,
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
            hints: const ['hint'],
            visible: true,
            solvedTimestamp: null,
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstWord = Word(
        id: 'id',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        hints: const ['hint'],
        visible: true,
        solvedTimestamp: 0,
      );
      final secondWord = Word(
        id: 'id',
        position: Point(1, 2),
        axis: Axis.horizontal,
        answer: 'test',
        clue: 'clue',
        hints: const ['hint'],
        visible: true,
        solvedTimestamp: 0,
      );

      expect(firstWord, equals(secondWord));
    });
  });
}
