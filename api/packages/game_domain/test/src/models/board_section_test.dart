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
            id: 'id',
            position: Point(1, 2),
            axis: Axis.horizontal,
            answer: 'answer',
            length: 6,
            clue: 'clue',
            solvedTimestamp: 1234,
            mascot: Mascots.android,
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
              'id': 'id',
              'position': {'x': 1, 'y': 2},
              'axis': 'horizontal',
              'answer': 'answer',
              'length': 6,
              'clue': 'clue',
              'solvedTimestamp': 1234,
              'mascot': 'android',
            },
          ],
          'borderWords': <Map<String, dynamic>>[],
          'snapshotUrl': null,
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
            'length': 6,
            'clue': 'clue',
            'solvedTimestamp': 1234,
            'mascot': 'android',
          },
        ],
        'borderWords': <Map<String, dynamic>>[],
        'snapshotUrl': null,
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
                id: 'id',
                position: Point(1, 2),
                axis: Axis.horizontal,
                answer: 'answer',
                length: 6,
                clue: 'clue',
                solvedTimestamp: 1234,
                mascot: Mascots.android,
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

    test('copyWith with a new id creates correct BoardSection object', () {
      final boardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        size: 300,
        words: [],
        borderWords: [],
      );
      final newBoardSection = boardSection.copyWith(id: 'newId');

      expect(
        newBoardSection,
        equals(
          BoardSection(
            id: 'newId',
            position: Point(1, 2),
            size: 300,
            words: [],
            borderWords: [],
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
          size: 300,
          words: [],
          borderWords: [],
        );
        final newBoardSection = boardSection.copyWith(position: Point(3, 4));

        expect(
          newBoardSection,
          equals(
            BoardSection(
              id: 'id',
              position: Point(3, 4),
              size: 300,
              words: [],
              borderWords: [],
            ),
          ),
        );
      },
    );

    test('copyWith with a new size creates correct BoardSection object', () {
      final boardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        size: 300,
        words: [],
        borderWords: [],
      );
      final newBoardSection = boardSection.copyWith(size: 400);

      expect(
        newBoardSection,
        equals(
          BoardSection(
            id: 'id',
            position: Point(1, 2),
            size: 400,
            words: [],
            borderWords: [],
          ),
        ),
      );
    });

    test('copyWith with new words creates correct BoardSection object', () {
      final boardSection = BoardSection(
        id: 'id',
        position: Point(1, 2),
        size: 300,
        words: [
          Word(
            id: '1',
            position: Point(1, 2),
            axis: Axis.horizontal,
            answer: 'answer',
            length: 6,
            clue: 'clue',
            solvedTimestamp: 1234,
          ),
        ],
        borderWords: [],
      );
      final newBoardSection = boardSection.copyWith(
        words: [
          Word(
            id: '2',
            position: Point(3, 4),
            axis: Axis.vertical,
            answer: 'newAnswer',
            length: 9,
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
            size: 300,
            words: [
              Word(
                id: '2',
                position: Point(3, 4),
                axis: Axis.vertical,
                answer: 'newAnswer',
                length: 9,
                clue: 'newClue',
                solvedTimestamp: 5678,
              ),
            ],
            borderWords: [],
          ),
        ),
      );
    });

    test(
      'copyWith with new borderWords creates correct BoardSection object',
      () {
        final boardSection = BoardSection(
          id: 'id',
          position: Point(1, 2),
          size: 300,
          words: [],
          borderWords: [
            Word(
              id: '1',
              position: Point(1, 2),
              axis: Axis.horizontal,
              answer: 'answer',
              length: 6,
              clue: 'clue',
              solvedTimestamp: 1234,
            ),
          ],
        );
        final newBoardSection = boardSection.copyWith(
          borderWords: [
            Word(
              id: '2',
              position: Point(3, 4),
              axis: Axis.vertical,
              answer: 'newAnswer',
              length: 9,
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
              size: 300,
              words: [],
              borderWords: [
                Word(
                  id: '2',
                  position: Point(3, 4),
                  axis: Axis.vertical,
                  answer: 'newAnswer',
                  length: 9,
                  clue: 'newClue',
                  solvedTimestamp: 5678,
                ),
              ],
            ),
          ),
        );
      },
    );

    test(
      'copyWith with new snapshotUrl creates correct BoardSection object',
      () {
        final boardSection = BoardSection(
          id: 'id',
          position: Point(1, 2),
          size: 300,
          words: [],
          borderWords: [],
          snapshotUrl: 'snapshotUrl',
        );
        final newBoardSection = boardSection.copyWith(
          snapshotUrl: 'newSnapshotUrl',
        );

        expect(
          newBoardSection,
          equals(
            BoardSection(
              id: 'id',
              position: Point(1, 2),
              size: 300,
              words: [],
              borderWords: [],
              snapshotUrl: 'newSnapshotUrl',
            ),
          ),
        );
      },
    );
  });
}
