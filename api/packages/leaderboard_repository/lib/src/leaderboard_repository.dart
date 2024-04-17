import 'dart:math';

import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';
import 'package:meta/meta.dart';

const _playersCollection = 'players';

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
    final mascot = Mascots.values.firstWhere((e) => e.name == mascotName);
    final player = Player(
      id: userId,
      initials: initials,
      mascot: mascot,
    );

    return _dbClient.set(
      _playersCollection,
      DbEntityRecord(
        id: player.id,
        data: player.toJson(),
      ),
    );
  }

  /// Updates the score for the provided user when it solves one word.
  Future<void> updateScore(String userId) async {
    final playerData = await _dbClient.getById(_playersCollection, userId);

    if (playerData == null) {
      return;
    }

    final player = Player.fromJson({
      'id': userId,
      ...playerData.data,
    });

    final updatedPlayerData = increaseScore(player);

    return _dbClient.set(
      _playersCollection,
      DbEntityRecord(
        id: updatedPlayerData.id,
        data: updatedPlayerData.toJson(),
      ),
    );
  }

  /// Increases the score for the provided score card.
  @visibleForTesting
  Player increaseScore(Player player) {
    final streak = player.streak;

    // Streak multiplier would be 1 for the first answer, 2 for the second,
    // and 10 * log(streak) for the rest. The series would look like:
    // 1, 2, 3, 5, 6, 7, 8, 8, 9, 10, 10, 10, 11...
    final streakMultiplier = streak < 2 ? streak + 1 : 10 * log(streak);

    const pointsPerWord = 10;
    final points = streakMultiplier * pointsPerWord;

    final updatedPlayerData = player.copyWith(
      score: player.score + points.round(),
      streak: player.streak + 1,
    );

    return updatedPlayerData;
  }

  /// Resets the streak for the provided user.
  Future<void> resetStreak(String userId) async {
    final playerData = await _dbClient.getById(_playersCollection, userId);

    if (playerData == null) {
      return;
    }

    final player = Player.fromJson({
      'id': userId,
      ...playerData.data,
    });

    final updatedPlayerData = player.copyWith(streak: 0);

    return _dbClient.set(
      _playersCollection,
      DbEntityRecord(
        id: updatedPlayerData.id,
        data: updatedPlayerData.toJson(),
      ),
    );
  }
}
