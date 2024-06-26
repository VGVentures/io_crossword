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
    this.player = Player.empty,
    this.rank = 0,
    this.mascot = Mascot.dash,
  });

  PlayerState copyWith({
    PlayerStatus? status,
    Player? player,
    int? rank,
    Mascot? mascot,
  }) {
    return PlayerState(
      status: status ?? this.status,
      player: player ?? this.player,
      rank: rank ?? this.rank,
      mascot: mascot ?? this.mascot,
    );
  }

  final PlayerStatus status;
  final Player player;
  final int rank;
  final Mascot mascot;

  @override
  List<Object?> get props => [status, player, rank, mascot];
}
