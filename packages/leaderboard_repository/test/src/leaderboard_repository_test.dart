// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:test/test.dart';

void main() {
  group('LeaderboardRepository', () {
    late FirebaseFirestore firestore;
    late LeaderboardRepository leaderboardRepository;
    late List<LeaderboardPlayer> players;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      leaderboardRepository = LeaderboardRepository(
        firestore: firestore,
      );

      players = [
        LeaderboardPlayer(
          userId: 'userId-1',
          initials: 'AAA',
          score: 9010,
          streak: 950,
          mascot: Mascots.android,
        ),
        LeaderboardPlayer(
          userId: 'userId-2',
          initials: 'BBB',
          score: 8010,
          streak: 750,
          mascot: Mascots.dash,
        ),
        LeaderboardPlayer(
          userId: 'userId-3',
          initials: 'CCC',
          score: 7010,
          streak: 650,
          mascot: Mascots.sparky,
        ),
        LeaderboardPlayer(
          userId: 'userId-4',
          initials: 'DDD',
          score: 6010,
          streak: 350,
          mascot: Mascots.dino,
        ),
        LeaderboardPlayer(
          userId: 'userId-5',
          initials: 'EEE',
          score: 5010,
          streak: 250,
          mascot: Mascots.dash,
        ),
        LeaderboardPlayer(
          userId: 'userId-6',
          initials: 'FFF',
          score: 410,
          streak: 150,
          mascot: Mascots.dino,
        ),
        LeaderboardPlayer(
          userId: 'userId-7',
          initials: 'GGG',
          score: 310,
          streak: 50,
          mascot: Mascots.android,
        ),
      ];

      for (final player in players) {
        await firestore.doc('leaderboard/${player.userId}').set(
              player.toJson(),
            );
      }
    });

    test('can be instantiated', () {
      expect(LeaderboardRepository(firestore: firestore), isNotNull);
    });

    group('getRankingPosition', () {
      test('returns the first position', () {
        expect(
          leaderboardRepository.getRankingPosition(players.first),
          emits(1),
        );
      });

      test('returns the second position', () {
        expect(
          leaderboardRepository.getRankingPosition(players[1]),
          emits(2),
        );
      });

      test('returns the third position', () {
        expect(
          leaderboardRepository.getRankingPosition(players[2]),
          emits(3),
        );
      });

      test('returns the six position player', () {
        expect(
          leaderboardRepository.getRankingPosition(players[5]),
          emits(6),
        );
      });

      test('returns the last position player', () {
        expect(
          leaderboardRepository.getRankingPosition(players.last),
          emits(7),
        );
      });
    });

    group('getLeaderboardPlayer', () {
      test('returns the fist player', () {
        final player = players.first;

        expect(
          leaderboardRepository.getLeaderboardPlayer(player.userId),
          emits(player),
        );
      });

      test('returns the second player', () {
        final player = players[1];

        expect(
          leaderboardRepository.getLeaderboardPlayer(player.userId),
          emits(player),
        );
      });

      test('returns the third player', () {
        final player = players[2];

        expect(
          leaderboardRepository.getLeaderboardPlayer(player.userId),
          emits(player),
        );
      });

      test('returns the last player', () {
        final player = players.last;

        expect(
          leaderboardRepository.getLeaderboardPlayer(player.userId),
          emits(player),
        );
      });

      test('reloads the user ranking when players information gets updated',
          () async {
        final player = players.last;

        expect(
          leaderboardRepository.getRankingPosition(player),
          emitsInOrder([7, 1]),
        );

        await firestore.doc('leaderboard/${player.userId}').set(
              player.toJson()..update('score', (value) => 9000000),
            );

        leaderboardRepository.getLeaderboardPlayer(player.userId);
      });
    });
  });
}
