part of 'word_selection_bloc.dart';

enum WordSelectionStatus {
  /// No word has been selected by the user.
  empty,

  /// The word has not yet been solved, but it is being considered
  /// by the user.
  preSolving,

  /// The user has committed to solve the word.
  solving,

  /// The user has submitted an answer to the word, and this is being
  /// validated.
  validating,

  /// The word has been solved.
  solved,

  /// The attempt to solve the word was incorrect, meaning that the
  /// user's answer was not the correct solution to the clue.
  incorrect,

  /// The attempt to solve the word has failed, but for an unknown
  /// reason.
  ///
  /// Most likely, the server couldn't validate the user's answer.
  failure;
}

class SelectedWord extends Equatable {
  const SelectedWord({
    required this.section,
    required this.word,
  });

  final (int, int) section;
  final Word word;

  SelectedWord copyWith({
    (int, int)? section,
    Word? word,
  }) {
    return SelectedWord(
      section: section ?? this.section,
      word: word ?? this.word,
    );
  }

  @override
  List<Object> get props => [section, word];
}

class WordSelectionState extends Equatable {
  const WordSelectionState({
    required this.status,
    this.word,
    this.wordPoints,
  });

  const WordSelectionState.initial()
      : status = WordSelectionStatus.empty,
        word = null,
        wordPoints = null;

  final WordSelectionStatus status;

  /// The word that is currently selected by the user.
  ///
  /// Is `null` if there is no word that is currently selected by
  /// the user.
  final SelectedWord? word;

  /// The amount of points that will be awarded to the user if the
  /// word is correctly solved.
  ///
  /// Is `null` if the word is has not yet been solved.
  final int? wordPoints;

  WordSelectionState copyWith({
    WordSelectionStatus? status,
    SelectedWord? word,
    int? wordPoints,
  }) {
    return WordSelectionState(
      status: status ?? this.status,
      word: word ?? this.word,
      wordPoints: wordPoints ?? this.wordPoints,
    );
  }

  @override
  List<Object?> get props => [word, status, wordPoints];
}
