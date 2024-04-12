part of 'word_selection_bloc.dart';

sealed class WordSelectionEvent extends Equatable {
  const WordSelectionEvent();
}

/// {@template word_solve_requested}
/// The user has requested to solve a word.
/// {@endtemplate}
class WordSolveRequested extends WordSelectionEvent {
  const WordSolveRequested({
    required this.wordIdentifier,
  });

  /// The unique identifier of the word that the user has requested to solve.
  final String wordIdentifier;

  @override
  List<Object> get props => [wordIdentifier];
}

class WordFocusedSuccessRequested extends WordSelectionEvent {
  const WordFocusedSuccessRequested();

  @override
  List<Object> get props => [];
}
