// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('$Player', () {
    test('empty', () {
      expect(
        Player.empty,
        equals(
          Player(
            id: '',
            initials: '',
            mascot: Mascots.dash,
          ),
        ),
      );
    });

    test('can be instantiated', () {
      expect(
        Player(
          id: 'id',
          initials: 'TST',
          score: 10,
          mascot: Mascots.android,
          streak: 2,
        ),
        isNotNull,
      );
    });

    final leaderboardPlayer = Player(
      id: 'id',
      initials: 'TST',
      score: 20,
      mascot: Mascots.android,
      streak: 2,
    );

    test('toJson returns the instance as json without the id', () {
      expect(
        leaderboardPlayer.toJson(),
        equals({
          'initials': 'TST',
          'score': 20,
          'mascot': Mascots.android.name,
          'streak': 2,
        }),
      );
    });

    test('fromJson returns the correct instance', () {
      expect(
        Player.fromJson({
          'id': 'id',
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
        Player(
          id: '',
          initials: 'TST',
          score: 20,
          mascot: Mascots.android,
          streak: 2,
        ),
        equals(
          Player(
            id: '',
            initials: 'TST',
            score: 20,
            mascot: Mascots.android,
            streak: 2,
          ),
        ),
      );

      expect(
        Player(
          id: '',
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
        Player(
          id: 'id',
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
        Player(
          id: 'id',
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
        Player(
          id: 'id',
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

    test('copyWith', () {
      expect(
        Player(
          id: 'id',
          initials: 'AAA',
          mascot: Mascots.android,
          streak: 10,
          score: 500,
        ).copyWith(),
        equals(
          Player(
            id: '',
            initials: '',
            mascot: Mascots.dash,
          ).copyWith(
            id: 'id',
            initials: 'AAA',
            mascot: Mascots.android,
            streak: 10,
            score: 500,
          ),
        ),
      );
    });
  });
}
