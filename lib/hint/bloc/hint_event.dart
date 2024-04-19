part of 'hint_bloc.dart';

sealed class HintEvent extends Equatable {
  const HintEvent();
}

class HintModeEntered extends HintEvent {
  const HintModeEntered();

  @override
  List<Object> get props => [];
}

class HintModeExited extends HintEvent {
  const HintModeExited();

  @override
  List<Object> get props => [];
}

class HintRequested extends HintEvent {
  const HintRequested(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
