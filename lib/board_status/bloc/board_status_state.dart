part of 'board_status_bloc.dart';

sealed class BoardStatusState extends Equatable {
  const BoardStatusState();

  @override
  List<Object> get props => [];
}

final class BoardStatusInitial extends BoardStatusState {
  const BoardStatusInitial();
}

class BoardStatusInProgress extends BoardStatusState {
  const BoardStatusInProgress();
}

class BoardStatusResetInProgress extends BoardStatusState {
  const BoardStatusResetInProgress();
}

class BoardStatusFailure extends BoardStatusState {
  const BoardStatusFailure();
}
