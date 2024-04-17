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
  });

  final LeaderboardStatus status;
  final List<Player> players;

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    List<Player>? players,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [status, players];
}
