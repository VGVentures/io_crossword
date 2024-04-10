part of 'word_focused_bloc.dart';

sealed class WordFocusedEvent extends Equatable {
  const WordFocusedEvent();
}

class WordFocusedSolveRequested extends WordFocusedEvent {
  const WordFocusedSolveRequested();

  @override
  List<Object> get props => [];
}

class WordFocusedSuccessRequested extends WordFocusedEvent {
  const WordFocusedSuccessRequested();

  @override
  List<Object> get props => [];
}

class SolvingFocusSwitched extends WordFocusedEvent {
  const SolvingFocusSwitched();

  @override
  List<Object> get props => [];
}
