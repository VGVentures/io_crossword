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

/// {@template word_solve_attempted}
/// The user has attempted to solve a word.
///
/// Such attempt might be successful or not.
/// {@endtemplate}
class WordSolveAttempted extends WordSelectionEvent {
  const WordSolveAttempted({required this.answer});

  /// The answer that the user believes is the correct solution to the clue.
  final String answer;

  @override
  List<Object?> get props => [answer];
}

class WordFocusedSuccessRequested extends WordSelectionEvent {
  const WordFocusedSuccessRequested();

  @override
  List<Object> get props => [];
}
