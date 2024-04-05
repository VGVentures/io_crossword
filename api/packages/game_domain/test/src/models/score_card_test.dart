// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('ScoreCard', () {
    test('can be instantiated', () {
      final scoreCard = ScoreCard(id: 'id');

      expect(scoreCard, isNotNull);
    });

    test('can be instantiated with default values', () {
      final scoreCard = ScoreCard(id: 'id');

      expect(scoreCard.totalScore, equals(0));
      expect(scoreCard.streak, equals(0));
      expect(scoreCard.mascot, equals(Mascots.dash));
      expect(scoreCard.initials, equals(''));
    });

    test('creates correct json object', () {
      final scoreCard = ScoreCard(
        id: 'id',
        totalScore: 10,
        streak: 5,
        mascot: Mascots.android,
        initials: 'ABC',
      );

      final json = scoreCard.toJson();

      expect(
        json,
        equals({
          'totalScore': 10,
          'streak': 5,
          'mascot': 'android',
          'initials': 'ABC',
        }),
      );
    });

    test('creates correct ScoreCard object from json', () {
      final scoreCard = ScoreCard.fromJson({
        'id': 'id',
        'totalScore': 10,
        'streak': 5,
        'mascot': 'android',
        'initials': 'ABC',
      });

      expect(
        scoreCard,
        equals(
          ScoreCard(
            id: 'id',
            totalScore: 10,
            streak: 5,
            mascot: Mascots.android,
            initials: 'ABC',
          ),
        ),
      );
    });

    test('copyWith keeps default values', () {
      final scoreCard = ScoreCard(
        id: 'id',
        totalScore: 10,
        streak: 5,
        mascot: Mascots.android,
        initials: 'ABC',
      );
      final updatedScoreCard = scoreCard.copyWith();

      expect(updatedScoreCard, equals(scoreCard));
    });
  });
}
