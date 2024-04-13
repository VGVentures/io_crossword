part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();
}

class LoadRequestedLeaderboardEvent extends LeaderboardEvent {
  const LoadRequestedLeaderboardEvent({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
