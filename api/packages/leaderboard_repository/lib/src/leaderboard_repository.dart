import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template leaderboard_repository}
/// Access to Leaderboard datasource.
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  const LeaderboardRepository({
    required DbClient dbClient,
    required String blacklistDocumentId,
  })  : _dbClient = dbClient,
        _blacklistDocumentId = blacklistDocumentId;

  final DbClient _dbClient;
  final String _blacklistDocumentId;

  /// Retrieves the leaderboard players.
  ///
  /// The players are ordered by longest streak and returns the top 10.
  Future<List<LeaderboardPlayer>> getLeaderboard() async {
    final results = await _dbClient.orderBy('leaderboard', 'score');

    return results
        .map(
          (e) => LeaderboardPlayer.fromJson({
            'userId': e.id,
            ...e.data,
          }),
        )
        .toList();
  }

  /// Saves player to the leaderboard.
  Future<void> addPlayerToLeaderboard({
    required LeaderboardPlayer leaderboardPlayer,
  }) async {
    return _dbClient.set(
      'leaderboard',
      DbEntityRecord(
        id: leaderboardPlayer.userId,
        data: leaderboardPlayer.toJson()..remove('userId'),
      ),
    );
  }

  /// Retrieves the blacklist for player initials.
  Future<List<String>> getInitialsBlacklist() async {
    final blacklistData = await _dbClient.getById(
      'initialsBlacklist',
      _blacklistDocumentId,
    );

    if (blacklistData == null) {
      return [];
    }

    return (blacklistData.data['blacklist'] as List).cast<String>();
  }

  /// Creates a score entry with the provided initials and mascot. The score
  /// related fields are initialized to 0.
  Future<void> createScore(
    String userId,
    String initials,
    String mascot,
  ) async {
    return _dbClient.set(
      'scoreCards',
      DbEntityRecord(
        id: userId,
        data: {
          'totalScore': 0,
          'streak': 0,
          'mascot': mascot,
          'initials': initials,
        },
      ),
    );
  }
}
