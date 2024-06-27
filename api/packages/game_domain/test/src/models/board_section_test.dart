// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('BoardSection', () {
    test('creates correct json object from BoardSection object', () {
      final boardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        words: [
          Word(
            id: 'id',
            position: Point(1, 2),
            axis: WordAxis.horizontal,
            answer: 'answer',
            clue: 'clue',
            solvedTimestamp: 1234,
            mascot: Mascot.android,
            userId: 'userId',
          ),
        ],
      );
      final json = boardSection.toJson();

      expect(
        json,
        equals({
          'position': {'x': 1, 'y': 2},
          'words': [
            {
              'id': 'id',
              'position': {'x': 1, 'y': 2},
              'axis': 'horizontal',
              'answer': 'answer',
              'clue': 'clue',
              'solvedTimestamp': 1234,
              'mascot': 'android',
              'userId': 'userId',
            },
          ],
        }),
      );
    });

    test('creates correct BoardSection object from json object', () {
      final json = {
        'id': 'id',
        'position': {'x': 1, 'y': 2},
        'words': [
          {
            'id': 'id',
            'position': {'x': 1, 'y': 2},
            'axis': 'horizontal',
            'answer': 'answer',
            'clue': 'clue',
            'solvedTimestamp': 1234,
            'mascot': 'android',
            'userId': 'userId',
          },
        ],
      };
      final boardSection = BoardSection.fromJson(json);
      expect(
        boardSection,
        equals(
          BoardSection(
            id: 'id',
            position: Point(1, 2),
            words: [
              Word(
                id: 'id',
                position: Point(1, 2),
                axis: WordAxis.horizontal,
                answer: 'answer',
                clue: 'clue',
                solvedTimestamp: 1234,
                mascot: Mascot.android,
                userId: 'userId',
              ),
            ],
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstBoardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        words: [],
      );
      final secondBoardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        words: [],
      );

      expect(firstBoardSection, equals(secondBoardSection));
    });

    test('copyWith with a new id creates correct BoardSection object', () {
      final boardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        words: [],
      );
      final newBoardSection = boardSection.copyWith(id: 'newId');

      expect(
        newBoardSection,
        equals(
          BoardSection(
            id: 'newId',
            position: Point(1, 2),
            words: [],
          ),
        ),
      );
    });

    test(
      'copyWith with a new position creates correct BoardSection object',
      () {
        final boardSection = BoardSection(
          id: 'id',
          position: Point(1, 2),
          words: [],
        );
        final newBoardSection = boardSection.copyWith(position: Point(3, 4));

        expect(
          newBoardSection,
          equals(
            BoardSection(
              id: 'id',
              position: Point(3, 4),
              words: [],
            ),
          ),
        );
      },
    );

    test('copyWith with new words creates correct BoardSection object', () {
      final boardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        words: [
          Word(
            id: '1',
            position: Point(1, 2),
            axis: WordAxis.horizontal,
            answer: 'answer',
            clue: 'clue',
            solvedTimestamp: 1234,
          ),
        ],
      );
      final newBoardSection = boardSection.copyWith(
        words: [
          Word(
            id: '2',
            position: Point(3, 4),
            axis: WordAxis.vertical,
            answer: 'newAnswer',
            clue: 'newClue',
            solvedTimestamp: 5678,
          ),
        ],
      );

      expect(
        newBoardSection,
        equals(
          BoardSection(
            id: 'id',
            position: Point(1, 2),
            words: [
              Word(
                id: '2',
                position: Point(3, 4),
                axis: WordAxis.vertical,
                answer: 'newAnswer',
                clue: 'newClue',
                solvedTimestamp: 5678,
              ),
            ],
          ),
        ),
      );
    });
  });
}
