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

class RenderModeSwitched extends CrosswordEvent {
  const RenderModeSwitched(this.renderMode);

  final RenderMode renderMode;

  @override
  List<Object?> get props => [renderMode];
}

class MascotSelected extends CrosswordEvent {
  const MascotSelected(this.mascot);

  final Mascots mascot;

  @override
  List<Object> get props => [mascot];
}

class BoardLoadingInfoFetched extends CrosswordEvent {
  const BoardLoadingInfoFetched();

  @override
  List<Object?> get props => [];
}

class InitialsSelected extends CrosswordEvent {
  const InitialsSelected(this.initials);

  final List<String> initials;

  @override
  List<Object> get props => [initials];
}

class AnswerFieldUpdated extends CrosswordEvent {
  const AnswerFieldUpdated(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}
