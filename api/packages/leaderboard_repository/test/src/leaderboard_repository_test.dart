// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('LeaderboardRepository', () {
    late DbClient dbClient;
    late LeaderboardRepository leaderboardRepository;

    const blacklistDocumentId = 'id';

    setUpAll(() {
      registerFallbackValue(DbEntityRecord(id: '', data: {}));
    });

    setUp(() {
      dbClient = _MockDbClient();
      leaderboardRepository = LeaderboardRepository(
        dbClient: dbClient,
        blacklistDocumentId: blacklistDocumentId,
      );
    });

    test('can be instantiated', () {
      expect(
        LeaderboardRepository(
          dbClient: dbClient,
          blacklistDocumentId: blacklistDocumentId,
        ),
        isNotNull,
      );
    });

    group('getLeaderboard', () {
      test('returns list of leaderboard players', () async {
        const playerOne = LeaderboardPlayer(
          userId: 'id',
          initials: 'AAA',
          score: 20,
        );
        const playerTwo = LeaderboardPlayer(
          userId: 'id2',
          initials: 'BBB',
          score: 10,
        );

        when(() => dbClient.orderBy('leaderboard', 'score'))
            .thenAnswer((_) async {
          return [
            DbEntityRecord(
              id: 'id',
              data: {
                'initials': playerOne.initials,
                'score': 20,
              },
            ),
            DbEntityRecord(
              id: 'id2',
              data: {
                'initials': playerTwo.initials,
                'score': 10,
              },
            ),
          ];
        });

        final result = await leaderboardRepository.getLeaderboard();

        expect(result, equals([playerOne, playerTwo]));
      });

      test('returns empty list if results are empty', () async {
        when(() => dbClient.orderBy('leaderboard', 'score'))
            .thenAnswer((_) async {
          return [];
        });

        final response = await leaderboardRepository.getLeaderboard();
        expect(response, isEmpty);
      });
    });

    group('addPlayerToLeaderboard', () {
      test('calls set with correct entity and record', () async {
        final leaderboardPlayer = LeaderboardPlayer(
          userId: 'user-id',
          initials: 'initials',
          score: 40,
        );

        final record = DbEntityRecord(
          id: 'user-id',
          data: {
            'initials': 'initials',
            'score': 40,
          },
        );

        when(() => dbClient.set('leaderboard', record))
            .thenAnswer((_) async {});

        await leaderboardRepository.addPlayerToLeaderboard(
          leaderboardPlayer: leaderboardPlayer,
        );

        verify(() => dbClient.set('leaderboard', record)).called(1);
      });
    });

    group('getInitialsBlacklist', () {
      const blacklist = ['AAA', 'BBB', 'CCC'];

      test('returns the blacklist', () async {
        when(() => dbClient.getById('initialsBlacklist', blacklistDocumentId))
            .thenAnswer(
          (_) async => DbEntityRecord(
            id: blacklistDocumentId,
            data: const {
              'blacklist': ['AAA', 'BBB', 'CCC'],
            },
          ),
        );

        final response = await leaderboardRepository.getInitialsBlacklist();
        expect(response, equals(blacklist));
      });

      test('returns empty list if not found', () async {
        when(() => dbClient.getById('initialsBlacklist', any())).thenAnswer(
          (_) async => null,
        );

        final response = await leaderboardRepository.getInitialsBlacklist();
        expect(response, isEmpty);
      });
    });

    group('createScore', () {
      test('completes when writing in the db is successful', () async {
        when(
          () => dbClient.set(
            'scoreCards',
            DbEntityRecord(
              id: 'userId',
              data: {
                'totalScore': 0,
                'streak': 0,
                'mascot': 'dash',
                'initials': 'ABC',
              },
            ),
          ),
        ).thenAnswer((_) async {});

        expect(
          leaderboardRepository.createScore('userId', 'ABC', 'dash'),
          completes,
        );
      });
    });

    group('updateScore', () {
      test('updates the score card in the database', () async {
        when(
          () => dbClient.getById('scoreCards', 'userId'),
        ).thenAnswer((_) async {
          return DbEntityRecord(
            id: 'userId',
            data: {
              'totalScore': 20,
              'streak': 3,
              'mascot': 'dash',
              'initials': 'ABC',
            },
          );
        });
        when(() => dbClient.set('scoreCards', any())).thenAnswer((_) async {});

        await leaderboardRepository.updateScore('userId');

        verify(() => dbClient.set('scoreCards', any())).called(1);
      });
    });

    group('increaseScore', () {
      test('updates the score correctly', () async {
        final newScoreCard = leaderboardRepository.increaseScore(
          ScoreCard(
            id: 'userId',
            totalScore: 20,
            streak: 1,
            mascot: Mascots.dash,
            initials: 'ABC',
          ),
        );

        expect(newScoreCard.totalScore, equals(40));
        expect(newScoreCard.streak, equals(2));
      });
    });

    group('resetStreak', () {
      test('saves the streak as 0 in the database', () async {
        when(
          () => dbClient.getById('scoreCards', 'userId'),
        ).thenAnswer((_) async {
          return DbEntityRecord(
            id: 'userId',
            data: {
              'totalScore': 20,
              'streak': 3,
              'mascot': 'dash',
              'initials': 'ABC',
            },
          );
        });
        when(() => dbClient.set('scoreCards', any())).thenAnswer((_) async {});

        await leaderboardRepository.resetStreak('userId');

        verify(
          () => dbClient.set(
            'scoreCards',
            DbEntityRecord(
              id: 'userId',
              data: {
                'totalScore': 20,
                'streak': 0,
                'mascot': 'dash',
                'initials': 'ABC',
              },
            ),
          ),
        ).called(1);
      });
    });
  });
}
