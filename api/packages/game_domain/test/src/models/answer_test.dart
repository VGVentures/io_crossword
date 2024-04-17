// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Answer', () {
    test('creates correct json object from Answer object', () {
      final answer = Answer(id: 'id', answer: 'answer', section: Point(1, 2));
      final json = answer.toJson();

      expect(
        json,
        equals({
          'answer': 'answer',
          'section': {'x': 1, 'y': 2},
        }),
      );
    });

    test('creates correct Answer object from json object', () {
      final json = {
        'id': 'id',
        'answer': 'answer',
        'section': {'x': 1, 'y': 2},
      };
      final answer = Answer.fromJson(json);
      expect(
        answer,
        equals(
          Answer(id: 'id', answer: 'answer', section: Point(1, 2)),
        ),
      );
    });

    test('supports equality', () {
      final firstAnswer = Answer(
        id: 'id',
        answer: 'answer',
        section: Point(1, 2),
      );
      final secondAnswer = Answer(
        id: 'id',
        answer: 'answer',
        section: Point(1, 2),
      );
      expect(firstAnswer, equals(secondAnswer));
    });
  });
}
