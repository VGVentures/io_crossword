part of 'crossword_bloc.dart';

sealed class CrosswordEvent extends Equatable {
  const CrosswordEvent();
}

class BoardSectionRequested extends CrosswordEvent {
  const BoardSectionRequested(this.position);

  final (int, int) position;

  @override
  List<Object> get props => [position];
}

class WordSelected extends CrosswordEvent {
  const WordSelected(this.section, this.wordId);

  final (int, int) section;
  final String wordId;

  @override
  List<Object> get props => [section, wordId];
}
