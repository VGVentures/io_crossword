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
      'initials_blacklist',
      _blacklistDocumentId,
    );

    if (blacklistData == null) {
      return [];
    }

    return (blacklistData.data['blacklist'] as List).cast<String>();
  }
}
