part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();
}

class LoadLeaderboardEvent extends LeaderboardEvent {
  const LoadLeaderboardEvent();

  @override
  List<Object?> get props => [];
}
