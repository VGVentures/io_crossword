part of 'word_focused_bloc.dart';

enum WordFocusedStatus {
  clue,
  solving,
  success,
}

enum WordSolvingFocus { word, hint }

class WordFocusedState extends Equatable {
  const WordFocusedState({
    this.status = WordFocusedStatus.clue,
    this.focus = WordSolvingFocus.word,
  });

  final WordFocusedStatus status;
  final WordSolvingFocus focus;

  WordFocusedState copyWith({
    WordFocusedStatus? status,
    WordSolvingFocus? focus,
  }) {
    return WordFocusedState(
      status: status ?? this.status,
      focus: focus ?? this.focus,
    );
  }

  @override
  List<Object?> get props => [status, focus];
}
