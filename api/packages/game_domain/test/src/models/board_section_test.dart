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
        size: 200,
        words: [
          Word(
            position: Point(1, 2),
            axis: Axis.horizontal,
            answer: 'answer',
            clue: 'clue',
            hints: ['hints'],
            solvedTimestamp: 1234,
          ),
        ],
        borderWords: [],
      );
      final json = boardSection.toJson();

      expect(
        json,
        equals({
          'position': {'x': 1, 'y': 2},
          'size': 200,
          'words': [
            {
              'position': {'x': 1, 'y': 2},
              'axis': 'horizontal',
              'answer': 'answer',
              'clue': 'clue',
              'hints': ['hints'],
              'visible': false,
              'solvedTimestamp': 1234,
            },
          ],
          'borderWords': <Map<String, dynamic>>[],
        }),
      );
    });

    test('creates correct BoardSection object from json object', () {
      final json = {
        'id': 'id',
        'position': {'x': 1, 'y': 2},
        'size': 200,
        'words': [
          {
            'id': 'id',
            'position': {'x': 1, 'y': 2},
            'axis': 'horizontal',
            'answer': 'answer',
            'clue': 'clue',
            'hints': ['hints'],
            'visible': false,
            'solvedTimestamp': 1234,
          },
        ],
        'borderWords': <Map<String, dynamic>>[],
      };
      final boardSection = BoardSection.fromJson(json);
      expect(
        boardSection,
        equals(
          BoardSection(
            id: 'id',
            position: Point(1, 2),
            size: 200,
            words: [
              Word(
                position: Point(1, 2),
                axis: Axis.horizontal,
                answer: 'answer',
                clue: 'clue',
                hints: ['hints'],
                solvedTimestamp: 1234,
              ),
            ],
            borderWords: [],
          ),
        ),
      );
    });

    test('supports equality', () {
      final firstBoardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        size: 300,
        words: [],
        borderWords: [],
      );
      final secondBoardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        size: 300,
        words: [],
        borderWords: [],
      );

      expect(firstBoardSection, equals(secondBoardSection));
    });
  });
}
