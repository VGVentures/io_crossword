part of 'player_bloc.dart';

enum PlayerStatus {
  onboarding,
  loading,
  playing,
  failure,
}

class PlayerState extends Equatable {
  const PlayerState({
    this.status = PlayerStatus.onboarding,
    this.leaderboardPlayer = LeaderboardPlayer.empty,
    this.rank = 0,
  });

  PlayerState copyWith({
    PlayerStatus? status,
    LeaderboardPlayer? leaderboardPlayer,
    int? rank,
  }) {
    return PlayerState(
      status: status ?? this.status,
      leaderboardPlayer: leaderboardPlayer ?? this.leaderboardPlayer,
      rank: rank ?? this.rank,
    );
  }

  final PlayerStatus status;
  final LeaderboardPlayer leaderboardPlayer;
  final int rank;

  @override
  List<Object?> get props => [status, leaderboardPlayer, rank];
}
