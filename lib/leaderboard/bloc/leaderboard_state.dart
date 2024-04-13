part of 'leaderboard_bloc.dart';

enum LeaderboardStatus {
  initial,
  success,
  failure,
}

class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.status = LeaderboardStatus.initial,
    this.players = const [],
    this.currentUserPosition = 0,
    this.currentPlayer,
  });

  final LeaderboardStatus status;
  final List<LeaderboardPlayer> players;

  // TODO(Ayad): Remove currentUserPosition and currentPlayer
  // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6445638020
  final int currentUserPosition;
  final LeaderboardPlayer? currentPlayer;

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    List<LeaderboardPlayer>? players,
    int? currentUserPosition,
    LeaderboardPlayer? currentPlayer,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      players: players ?? this.players,
      currentUserPosition: currentUserPosition ?? this.currentUserPosition,
      currentPlayer: currentPlayer ?? this.currentPlayer,
    );
  }

  @override
  List<Object?> get props =>
      [status, players, currentUserPosition, currentPlayer];
}
