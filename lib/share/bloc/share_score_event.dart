part of 'share_score_bloc.dart';

sealed class ShareScoreEvent extends Equatable {
  const ShareScoreEvent();
}

class ShareScoreSolveRequested extends ShareScoreEvent {
  const ShareScoreSolveRequested();

  @override
  List<Object> get props => [];
}

class ShareScoreSuccessRequested extends ShareScoreEvent {
  const ShareScoreSuccessRequested();

  @override
  List<Object> get props => [];
}

class SolvingFocusSwitched extends ShareScoreEvent {
  const SolvingFocusSwitched();

  @override
  List<Object> get props => [];
}
