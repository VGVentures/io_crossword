part of 'word_selection_bloc.dart';

sealed class WordSelectionEvent extends Equatable {
  const WordSelectionEvent();
}

/// {@template word_selected}
/// The user has selected a word.
///
/// The user is yet to decide if they want to solve the word or not.
/// {@endtemplate}
class WordSelected extends WordSelectionEvent {
  const WordSelected({
    required this.selectedWord,
  });

  /// The unique identifier of the word that the user has selected.
  final SelectedWord selectedWord;

  @override
  List<Object> get props => [selectedWord];
}

/// {@template letter_selected}
/// The user has selected a crossword letter.
///
/// If the letter is part of a single word, the word is selected. Hence, the
/// behavior is analogous to [WordSelected].
///
/// However, a letter might be part of at most two words (horizontal and
/// vertical). If so, the horizontal word is always preferred over the vertical
/// word, unless it has already been selected.
///
/// Note that a [CrosswordLetterData] must have at least one
/// [CrosswordLetterData.words], since a letter must be part of at least one
/// word for it to be part of the crossword.
/// {@endtemplate}
class LetterSelected extends WordSelectionEvent {
  const LetterSelected({
    required this.letter,
  });

  /// {@macro crossword_letter_data}
  final CrosswordLetterData letter;

  @override
  List<Object> get props => [letter];
}

/// {@template word_unselected}
/// The user has unselected a word.
///
/// This means that the user is no longer interested in solving the word.
/// {@endtemplate}
class WordUnselected extends WordSelectionEvent {
  const WordUnselected();

  @override
  List<Object> get props => [];
}

/// {@template word_solve_requested}
/// The user has requested to solve a word.
/// {@endtemplate}
class WordSolveRequested extends WordSelectionEvent {
  const WordSolveRequested();

  @override
  List<Object> get props => [];
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
