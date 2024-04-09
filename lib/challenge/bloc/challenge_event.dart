part of 'challenge_bloc.dart';

sealed class ChallengeEvent extends Equatable {
  const ChallengeEvent();

  @override
  List<Object> get props => [];
}

/// Requests the data needed for the challenge progress.
class ChallengeDataRequested extends ChallengeEvent {
  const ChallengeDataRequested();
}
