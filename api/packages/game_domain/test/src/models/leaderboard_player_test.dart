// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardPlayer', () {
    test('can be instantiated', () {
      expect(
        LeaderboardPlayer(
          id: 'id',
          initials: 'TST',
        ),
        isNotNull,
      );
    });

    final leaderboardPlayer = LeaderboardPlayer(
      id: 'id',
      initials: 'TST',
    );

    test('toJson returns the instance as json', () {
      expect(
        leaderboardPlayer.toJson(),
        equals({
          'id': 'id',
          'initials': 'TST',
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        LeaderboardPlayer.fromJson(const {
          'id': 'id',
          'initials': 'TST',
        }),
        equals(leaderboardPlayer),
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardPlayer(id: '', initials: 'TST'),
        equals(LeaderboardPlayer(id: '', initials: 'TST')),
      );

      expect(
        LeaderboardPlayer(
          id: '',
          initials: 'TST',
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );

      expect(
        LeaderboardPlayer(
          id: 'id',
          initials: 'WOW',
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );
    });
  });
}
