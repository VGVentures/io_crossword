part of 'word_selection_bloc.dart';

sealed class WordSelectionEvent extends Equatable {
  const WordSelectionEvent();
}

class WordFocusedSolveRequested extends WordSelectionEvent {
  const WordFocusedSolveRequested();

  @override
  List<Object> get props => [];
}

class WordFocusedSuccessRequested extends WordSelectionEvent {
  const WordFocusedSuccessRequested();

  @override
  List<Object> get props => [];
}
