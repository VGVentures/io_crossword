import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';
import 'package:rxdart/rxdart.dart';

/// {@template leaderboard_repository}
/// Leaderboard repository
/// {@endtemplate}
class LeaderboardRepository {
  /// {@macro leaderboard_repository}
  const LeaderboardRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  BehaviorSubject<int>? _userRanking;

  /// Returns a [Stream] with the users ranking.
  Stream<int> getUserRanking(LeaderboardPlayer player) async {
    try {
      if (_userRanking == null) {
        _userRanking = BehaviorSubject();

        final userRank = await _firestore
            .collection('leaderboard')
            .where(
              'score',
              isGreaterThan: player.score,
            )
            .count()
            .get();

        _userRanking!.add(userRank.count ?? 0);
      }

      return _userRanking!.stream;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetGalleryFailure(error), stackTrace);
    }
  }
}
