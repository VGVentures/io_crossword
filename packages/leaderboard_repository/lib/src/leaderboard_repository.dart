import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:rxdart/rxdart.dart';

const _collection = 'leaderboard';

/// {@template leaderboard_repository}
/// Leaderboard repository
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  LeaderboardRepository({
    required FirebaseFirestore firestore,
  })  : _leaderboardCollection = firestore.collection(_collection),
        _userRankingPosition = BehaviorSubject<int>();

  late final CollectionReference<Map<String, dynamic>> _leaderboardCollection;

  final BehaviorSubject<int> _userRankingPosition;
  BehaviorSubject<LeaderboardPlayer>? _leaderboardPlayer;

  /// Returns a [Stream] with the users position in the ranking.
  Stream<int> getRankingPosition(LeaderboardPlayer player) {
    _leaderboardCollection
        .where('score', isGreaterThan: player.score)
        .count()
        .get()
        .then((userRank) => _userRankingPosition.add((userRank.count ?? 0) + 1))
        .onError(_userRankingPosition.addError);

    return _userRankingPosition.stream;
  }

  /// Returns a [Stream] of [LeaderboardPlayer] with the users
  /// information in the leaderboard.
  Stream<LeaderboardPlayer> getLeaderboardPlayer(String userId) {
    if (_leaderboardPlayer != null) return _leaderboardPlayer!.stream;

    _leaderboardPlayer = BehaviorSubject<LeaderboardPlayer>();

    _leaderboardCollection
        .doc(userId)
        .snapshots()
        .map((snapshot) => LeaderboardPlayer.fromJson(snapshot.data()!))
        .listen(_leaderboardPlayer!.add)
        .onError(_leaderboardPlayer!.addError);

    return _leaderboardPlayer!.stream;
  }

  /// Returns the [LeaderboardPlayer] with the ranking position in
  /// the leaderboard.
  Stream<(LeaderboardPlayer, int)> getPlayerRanked(String userId) {
    final stream = BehaviorSubject<(LeaderboardPlayer, int)>();

    getLeaderboardPlayer(userId).listen((player) {
      // each time the player gets updated the ranking will also get updated
      getRankingPosition(player).listen((rank) {
        stream.add((player, rank));
      });
    });

    return stream.stream;
  }
}
