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
            'players',
            DbEntityRecord(
              id: 'userId',
              data: {
                'score': 0,
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
          () => dbClient.getById('players', 'userId'),
        ).thenAnswer((_) async {
          return DbEntityRecord(
            id: 'userId',
            data: {
              'score': 20,
              'streak': 3,
              'mascot': 'dash',
              'initials': 'ABC',
            },
          );
        });
        when(() => dbClient.set('players', any())).thenAnswer((_) async {});

        await leaderboardRepository.updateScore('userId');

        verify(() => dbClient.set('players', any())).called(1);
      });
    });

    group('increaseScore', () {
      test('updates the score correctly', () async {
        final newScoreCard = leaderboardRepository.increaseScore(
          Player(
            id: 'userId',
            score: 20,
            streak: 1,
            mascot: Mascots.dash,
            initials: 'ABC',
          ),
        );

        expect(newScoreCard.score, equals(40));
        expect(newScoreCard.streak, equals(2));
      });
    });

    group('resetStreak', () {
      test('saves the streak as 0 in the database', () async {
        when(
          () => dbClient.getById('players', 'userId'),
        ).thenAnswer((_) async {
          return DbEntityRecord(
            id: 'userId',
            data: {
              'score': 20,
              'streak': 3,
              'mascot': 'dash',
              'initials': 'ABC',
            },
          );
        });
        when(() => dbClient.set('players', any())).thenAnswer((_) async {});

        await leaderboardRepository.resetStreak('userId');

        verify(
          () => dbClient.set(
            'players',
            DbEntityRecord(
              id: 'userId',
              data: {
                'score': 20,
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
