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
    this.player = LeaderboardPlayer.empty,
    this.rank = 0,
  });

  PlayerState copyWith({
    PlayerStatus? status,
    LeaderboardPlayer? player,
    int? rank,
  }) {
    return PlayerState(
      status: status ?? this.status,
      player: player ?? this.player,
      rank: rank ?? this.rank,
    );
  }

  final PlayerStatus status;
  final LeaderboardPlayer player;
  final int rank;

  @override
  List<Object?> get props => [status, player, rank];
}
