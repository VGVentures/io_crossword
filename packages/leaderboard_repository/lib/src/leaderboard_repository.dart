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
        _leaderboardPlayer = BehaviorSubject<LeaderboardPlayer>(),
        _userRankingPosition = BehaviorSubject<int>();

  late final CollectionReference<Map<String, dynamic>> _leaderboardCollection;

  final BehaviorSubject<int> _userRankingPosition;
  final BehaviorSubject<LeaderboardPlayer> _leaderboardPlayer;

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
    _leaderboardCollection
        .doc(userId)
        .snapshots()
        .map((snapshot) => LeaderboardPlayer.fromJson(snapshot.data()!))
        .listen((player) {
      _leaderboardPlayer.add(player);
      // each time this listen is triggered we will call the ranking position
      // to get updated
      getRankingPosition(player);
    }).onError(_leaderboardPlayer.addError);

    return _leaderboardPlayer;
  }
}
