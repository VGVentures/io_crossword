// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardPlayer', () {
    test('empty', () {
      expect(
        LeaderboardPlayer.empty,
        equals(
          LeaderboardPlayer(
            userId: '',
            initials: '',
            score: 0,
            streak: 0,
            mascot: Mascots.dash,
          ),
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        LeaderboardPlayer(
          userId: 'id',
          initials: 'TST',
          score: 10,
          mascot: Mascots.android,
          streak: 2,
        ),
        isNotNull,
      );
    });

    final leaderboardPlayer = LeaderboardPlayer(
      userId: 'id',
      initials: 'TST',
      score: 20,
      mascot: Mascots.android,
      streak: 2,
    );

    test('toJson returns the instance as json', () {
      expect(
        leaderboardPlayer.toJson(),
        equals({
          'userId': 'id',
          'initials': 'TST',
          'score': 20,
          'mascot': Mascots.android.name,
          'streak': 2,
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        LeaderboardPlayer.fromJson({
          'userId': 'id',
          'initials': 'TST',
          'score': 20,
          'mascot': Mascots.android.name,
          'streak': 2,
        }),
        equals(leaderboardPlayer),
      );
    });

    test('supports equality', () {
      expect(
        LeaderboardPlayer(
          userId: '',
          initials: 'TST',
          score: 20,
          mascot: Mascots.android,
          streak: 2,
        ),
        equals(
          LeaderboardPlayer(
            userId: '',
            initials: 'TST',
            score: 20,
            mascot: Mascots.android,
            streak: 2,
          ),
        ),
      );

      expect(
        LeaderboardPlayer(
          userId: '',
          initials: 'TST',
          score: 20,
          mascot: Mascots.android,
          streak: 2,
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
          mascot: Mascots.android,
          streak: 2,
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );

      expect(
        LeaderboardPlayer(
          userId: 'id',
          initials: 'TST',
          score: 20,
          mascot: Mascots.dash,
          streak: 2,
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );

      expect(
        LeaderboardPlayer(
          userId: 'id',
          initials: 'TST',
          score: 20,
          mascot: Mascots.android,
          streak: 3,
        ),
        isNot(
          equals(leaderboardPlayer),
        ),
      );
    });
  });
}
