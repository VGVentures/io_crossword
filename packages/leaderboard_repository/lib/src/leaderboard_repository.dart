import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

const _collection = 'players';

/// {@template leaderboard_repository}
/// Leaderboard repository
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  LeaderboardRepository({
    required FirebaseFirestore firestore,
  })  : _leaderboardCollection = firestore.collection(_collection),
        userRankingPosition = BehaviorSubject<int>();

  late final CollectionReference<Map<String, dynamic>> _leaderboardCollection;

  /// The users ranking position stream.
  @visibleForTesting
  final BehaviorSubject<int> userRankingPosition;
  BehaviorSubject<Player>? _leaderboardPlayer;
  BehaviorSubject<(Player, int)>? _playerRanked;

  /// Updates the [userRankingPosition] of the current user.
  @visibleForTesting
  void updateUsersRankingPosition(int position) {
    userRankingPosition.add(position);
  }

  /// Retrieves the leaderboard players.
  ///
  /// The players are ordered by longest streak and returns the top 10.
  Future<List<Player>> getLeaderboardResults(String userId) async {
    final results = await _leaderboardCollection
        .orderBy('score', descending: true)
        .limit(10)
        .get();

    final players = results.docs
        .map(
          (e) => Player.fromJson({
            'id': e.id,
            ...e.data(),
          }),
        )
        .toList();

    final foundCurrentUser = players.where((player) => player.id == userId);

    if (foundCurrentUser.isNotEmpty) {
      // We want to update the users ranking to show the latest position.
      updateUsersRankingPosition(
        players.indexOf(foundCurrentUser.first) + 1,
      );
    }

    return players;
  }

  /// Returns a [Stream] with the users position in the ranking.
  @visibleForTesting
  Stream<int> getRankingPosition(Player player) {
    _leaderboardCollection
        .where('score', isGreaterThan: player.score)
        .count()
        .get()
        .then((userRank) => userRankingPosition.add((userRank.count ?? 0) + 1))
        .onError(userRankingPosition.addError);

    return userRankingPosition.stream;
  }

  /// Returns a [Stream] of [Player] with the users
  /// information in the leaderboard.
  Stream<Player> getPlayer(String userId) {
    if (_leaderboardPlayer != null) return _leaderboardPlayer!.stream;

    _leaderboardPlayer = BehaviorSubject<Player>();

    _leaderboardCollection
        .doc(userId)
        .snapshots()
        .map(
          (snapshot) {
            if (!snapshot.exists) return Player.empty;

            return Player.fromJson({
              'id': snapshot.id,
              ...snapshot.data()!,
            });
          },
        )
        .listen(_leaderboardPlayer!.add)
        .onError(_leaderboardPlayer!.addError);

    return _leaderboardPlayer!.stream;
  }

  /// Returns the [Player] with the ranking position in
  /// the leaderboard.
  Stream<(Player, int)> getPlayerRanked(String userId) {
    if (_playerRanked != null) return _playerRanked!.stream;

    _playerRanked = BehaviorSubject<(Player, int)>();

    getPlayer(userId).listen((player) {
      // each time the player gets updated the ranking will also get updated
      getRankingPosition(player).listen((rank) {
        _playerRanked!.add((player, rank));
      });
    });

    return _playerRanked!.stream;
  }
}
