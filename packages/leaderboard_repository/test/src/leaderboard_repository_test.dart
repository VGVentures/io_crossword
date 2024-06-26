// ignore_for_file: prefer_const_constructors

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

void main() {
  group('$LeaderboardRepository', () {
    late FakeFirebaseFirestore firestore;
    late LeaderboardRepository leaderboardRepository;
    late List<Player> players;

    setUp(() async {
      firestore = FakeFirebaseFirestore();
      leaderboardRepository = LeaderboardRepository(
        firestore: firestore,
      );

      players = [
        Player(
          id: 'userId-1',
          initials: 'AAA',
          score: 9010,
          streak: 950,
          mascot: Mascot.android,
        ),
        Player(
          id: 'userId-2',
          initials: 'BBB',
          score: 8010,
          streak: 750,
          mascot: Mascot.dash,
        ),
        Player(
          id: 'userId-3',
          initials: 'CCC',
          score: 7010,
          streak: 650,
          mascot: Mascot.sparky,
        ),
        Player(
          id: 'userId-4',
          initials: 'DDD',
          score: 6010,
          streak: 350,
          mascot: Mascot.dino,
        ),
        Player(
          id: 'userId-5',
          initials: 'EEE',
          score: 5010,
          streak: 250,
          mascot: Mascot.dash,
        ),
        Player(
          id: 'userId-6',
          initials: 'FFF',
          score: 410,
          streak: 150,
          mascot: Mascot.dino,
        ),
        Player(
          id: 'userId-7',
          initials: 'GGG',
          score: 310,
          streak: 50,
          mascot: Mascot.android,
        ),
      ];

      for (final player in players) {
        await firestore.doc('players/${player.id}').set(
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

    group('updateUsersRankingPosition', () {
      test('updates user ranking score', () {
        leaderboardRepository.updateUsersRankingPosition(2);

        expect(
          leaderboardRepository.userRankingPosition.stream,
          emits(2),
        );
      });
    });

    group('getLeaderboardResults', () {
      test('returns the players', () async {
        expect(
          await leaderboardRepository.getLeaderboardResults('id'),
          equals(players),
        );
      });

      test('returns the players with limit of 10', () async {
        for (final player in List.generate(
          11,
          (index) => Player(
            id: 'userId+$index',
            initials: 'AAA',
            score: 20,
            mascot: Mascot.dash,
          ),
        )) {
          await firestore.doc('players/${player.id}').set(
                player.toJson(),
              );
        }

        expect(
          await leaderboardRepository.getLeaderboardResults('id'),
          hasLength(10),
        );
      });

      test(
        'does not call updateUsersRankingPosition when not in top 10',
        () async {
          await leaderboardRepository.getLeaderboardResults('id');

          expect(leaderboardRepository.userRankingPosition, emitsInOrder([]));
        },
      );

      test(
        'calls updateUsersRankingPosition when the ranking gets updated',
        () async {
          leaderboardRepository.updateUsersRankingPosition(9);

          await leaderboardRepository.getLeaderboardResults(players.first.id);

          expect(
            leaderboardRepository.userRankingPosition.stream,
            emits(1),
          );
        },
      );
    });

    group('getPlayer', () {
      test('returns empty player when cannot find player', () {
        expect(
          leaderboardRepository.getPlayer('no-player'),
          emits(Player.empty),
        );
      });

      test('returns the fist player', () {
        final player = players.first;

        expect(
          leaderboardRepository.getPlayer(player.id),
          emits(player),
        );
      });

      test('returns the second player', () {
        final player = players[1];

        expect(
          leaderboardRepository.getPlayer(player.id),
          emits(player),
        );
      });

      test('returns the third player', () {
        final player = players[2];

        expect(
          leaderboardRepository.getPlayer(player.id),
          emits(player),
        );
      });

      test('returns the last player', () {
        final player = players.last;

        expect(
          leaderboardRepository.getPlayer(player.id),
          emits(player),
        );
      });
    });

    group('getPlayerRanked', () {
      test('displays the user with the first rank', () async {
        final player = players.first;

        expect(
          leaderboardRepository.getPlayerRanked(player.id),
          emits((player, 1)),
        );
      });

      test('displays the user with the second rank', () async {
        final player = players[1];

        expect(
          leaderboardRepository.getPlayerRanked(player.id),
          emits((player, 2)),
        );
      });

      test('displays the user with the last rank', () async {
        final player = players.last;

        expect(
          leaderboardRepository.getPlayerRanked(player.id),
          emits((player, 7)),
        );
      });

      test('reloads the user ranking when players information gets updated',
          () async {
        final player = players.last;

        expect(
          leaderboardRepository.getRankingPosition(player),
          emitsInOrder([7, 1]),
        );

        await firestore.doc('players/${player.id}').set(
              player.toJson()..update('score', (value) => 9000000),
            );

        leaderboardRepository.getPlayerRanked(player.id);
      });
    });
  });
}
