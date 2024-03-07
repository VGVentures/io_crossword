// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardPlayer', () {
    test('can be instantiated', () {
      expect(
        LeaderboardPlayer(
          userId: 'id',
          initials: 'TST',
          score: 10,
        ),
        isNotNull,
      );
    });

    final leaderboardPlayer = LeaderboardPlayer(
      userId: 'id',
      initials: 'TST',
      score: 20,
    );

    test('toJson returns the instance as json', () {
      expect(
        leaderboardPlayer.toJson(),
        equals({
          'id': 'id',
          'initials': 'TST',
          'score': 20,
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        LeaderboardPlayer.fromJson(const {
          'id': 'id',
          'initials': 'TST',
          'score': 20,
        }),
        equals(leaderboardPlayer),
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardPlayer(userId: '', initials: 'TST', score: 20),
        equals(LeaderboardPlayer(userId: '', initials: 'TST', score: 20)),
      );

      expect(
        LeaderboardPlayer(
          userId: '',
          initials: 'TST',
          score: 20,
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );

      expect(
        LeaderboardPlayer(
          userId: 'id',
          initials: 'WOW',
          score: 20,
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );
    });
  });
}
