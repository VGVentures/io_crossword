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

class RenderModeSwitched extends CrosswordEvent {
  const RenderModeSwitched(this.renderMode);

  final RenderMode renderMode;

  @override
  List<Object?> get props => [renderMode];
}
