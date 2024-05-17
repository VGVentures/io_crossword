part of 'board_status_bloc.dart';

sealed class BoardStatusEvent extends Equatable {
  const BoardStatusEvent();
}

class BoardStatusRequested extends BoardStatusEvent {
  const BoardStatusRequested();

  @override
  List<Object> get props => [];
}
