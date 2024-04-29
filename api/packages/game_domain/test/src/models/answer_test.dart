// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Answer', () {
    test('creates correct json object from Answer object', () {
      final answer = Answer(
        id: 'id',
        answer: 'answer',
        sections: const [Point(1, 2)],
        collidedWords: const [
          CollidedWord(
            wordId: 'word-id',
            position: 3,
            character: 'b',
          ),
        ],
      );
      final json = answer.toJson();

      expect(
        json,
        equals({
          'answer': 'answer',
          'sections': [
            {'x': 1, 'y': 2},
          ],
          'collidedWords': [
            {
              'wordId': 'word-id',
              'position': 3,
              'character': 'b',
            },
          ],
        }),
      );
    });

    test('creates correct Answer object from json object', () {
      final json = {
        'id': 'id',
        'answer': 'answer',
        'sections': [
          {'x': 1, 'y': 2},
        ],
        'collidedWords': [
          {
            'wordId': 'word-id',
            'position': 3,
            'character': 'b',
          },
        ],
      };
      final answer = Answer.fromJson(json);
      expect(
        answer,
        equals(
          Answer(
            id: 'id',
            answer: 'answer',
            sections: const [Point(1, 2)],
            collidedWords: const [
              CollidedWord(
                wordId: 'word-id',
                position: 3,
                character: 'b',
              ),
            ],
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstAnswer = Answer(
        id: 'id',
        answer: 'answer',
        sections: const [Point(1, 2)],
        collidedWords: const [
          CollidedWord(
            wordId: 'word-id',
            position: 3,
            character: 'b',
          ),
        ],
      );
      final secondAnswer = Answer(
        id: 'id',
        answer: 'answer',
        sections: const [Point(1, 2)],
        collidedWords: const [
          CollidedWord(
            wordId: 'word-id',
            position: 3,
            character: 'b',
          ),
        ],
      );
      expect(firstAnswer, equals(secondAnswer));
    });
  });
}
