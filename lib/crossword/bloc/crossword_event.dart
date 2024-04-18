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
  const WordSelected(this.section, this.word);

  final (int, int) section;
  final Word word;

  @override
  List<Object> get props => [section, word];
}

class WordUnselected extends CrosswordEvent {
  const WordUnselected();

  @override
  List<Object> get props => [];
}

class BoardLoadingInformationRequested extends CrosswordEvent {
  const BoardLoadingInformationRequested();

  @override
  List<Object?> get props => [];
}
