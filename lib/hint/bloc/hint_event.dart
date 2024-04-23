part of 'hint_bloc.dart';

sealed class HintEvent extends Equatable {
  const HintEvent();
}

class HintEnabledRequested extends HintEvent {
  const HintEnabledRequested();

  @override
  List<Object> get props => [];
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
  const HintRequested({
    required this.wordId,
    required this.question,
  });

  final String wordId;
  final String question;

  @override
  List<Object> get props => [wordId, question];
}

class PreviousHintsRequested extends HintEvent {
  const PreviousHintsRequested(this.wordId);

  final String wordId;

  @override
  List<Object> get props => [wordId];
}
