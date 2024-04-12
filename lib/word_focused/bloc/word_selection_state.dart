part of 'word_selection_bloc.dart';

enum WordSelectionStatus {
  /// The word has not yet been solved, but it is being considered
  /// by the user.
  preSolving,

  /// The user has committed to solve the word.
  solving,
  success,
}

class WordSelectionState extends Equatable {
  const WordSelectionState({
    required this.status,
    this.wordIdentifier,
    this.wordPoints,
  });

  const WordSelectionState.initial()
      : status = WordSelectionStatus.preSolving,
        wordIdentifier = null,
        wordPoints = null;

  final WordSelectionStatus status;

  /// The unique identifier of the word.
  ///
  /// Is `null` if there is no word that is currently selected by
  /// the user.
  final String? wordIdentifier;

  /// The amount of points that will be awarded to the user if the
  /// word is correctly solved.
  ///
  /// Is `null` if the word is has not yet been solved.
  final int? wordPoints;

  WordSelectionState copyWith({
    WordSelectionStatus? status,
    String? wordIdentifier,
    int? wordPoints,
  }) {
    return WordSelectionState(
      status: status ?? this.status,
      wordIdentifier: wordIdentifier ?? this.wordIdentifier,
      wordPoints: wordPoints ?? this.wordPoints,
    );
  }

  @override
  List<Object?> get props => [wordIdentifier, status, wordPoints];
}
