import 'dart:math';

import 'package:collection/collection.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:meta/meta.dart';

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
    String mascotName,
  ) async {
    final mascot = Mascots.values.firstWhereOrNull((e) => e.name == mascotName);
    final scoreCard = ScoreCard(
      id: userId,
      initials: initials,
      mascot: mascot,
    );

    return _dbClient.set(
      'scoreCards',
      DbEntityRecord(
        id: scoreCard.id,
        data: scoreCard.toJson(),
      ),
    );
  }

  /// Updates the score for the provided user when it solves one word.
  Future<void> updateScore(String userId) async {
    final scoreData = await _dbClient.getById('scoreCards', userId);

    if (scoreData == null) {
      return;
    }

    final scoreCard = ScoreCard.fromJson({
      'id': userId,
      ...scoreData.data,
    });

    final updatedScoreCard = increaseScore(scoreCard);

    return _dbClient.set(
      'scoreCards',
      DbEntityRecord(
        id: updatedScoreCard.id,
        data: updatedScoreCard.toJson(),
      ),
    );
  }

  /// Increases the score for the provided score card.
  @visibleForTesting
  ScoreCard increaseScore(ScoreCard scoreCard) {
    final streak = scoreCard.streak;

    // Streak multiplier would be 1 for the first answer, 2 for the second,
    // and 10 * log(streak) for the rest. The series would look like:
    // 1, 2, 3, 5, 6, 7, 8, 8, 9, 10, 10, 10, 11...
    final streakMultiplier = streak < 2 ? streak + 1 : 10 * log(streak);

    const pointsPerWord = 10;
    final points = streakMultiplier * pointsPerWord;

    final updatedScoreCard = scoreCard.copyWith(
      totalScore: scoreCard.totalScore + points.round(),
      streak: scoreCard.streak + 1,
    );

    return updatedScoreCard;
  }

  /// Resets the streak for the provided user.
  Future<void> resetStreak(String userId) async {
    final scoreData = await _dbClient.getById('scoreCards', userId);

    if (scoreData == null) {
      return;
    }

    final scoreCard = ScoreCard.fromJson({
      'id': userId,
      ...scoreData.data,
    });

    final updatedScoreCard = scoreCard.copyWith(streak: 0);

    return _dbClient.set(
      'scoreCards',
      DbEntityRecord(
        id: updatedScoreCard.id,
        data: updatedScoreCard.toJson(),
      ),
    );
  }
}
