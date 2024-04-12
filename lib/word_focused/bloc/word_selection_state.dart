part of 'word_selection_bloc.dart';

/// {@template word_selection_status}
/// The status of the word selection.
/// {@endtemplate}
enum WordSelectionStatus {
  clue,
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
      : status = WordSelectionStatus.clue,
        wordIdentifier = null,
        wordPoints = null;

  /// {@macro word_selection_status}
  final WordSelectionStatus status;

  /// The unique identifier of the word.
  ///
  /// Is `null` if there is no word that is currently selected by
  /// the user.
  final String? wordIdentifier;

  /// The amount of points that will be awarded to the user if the
  /// word is correctly solved.
  ///
  /// Is `null` if the word is not yet solved.
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
