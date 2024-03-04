part of 'crossword_bloc.dart';

sealed class CrosswordEvent extends Equatable {
  const CrosswordEvent();
}

class InitialBoardLoadRequested extends CrosswordEvent {
  const InitialBoardLoadRequested();

  @override
  List<Object> get props => [];
}

class BoardSectionRequested extends CrosswordEvent {
  const BoardSectionRequested(this.position);

  final (int, int) position;

  @override
  List<Object> get props => [position];
}
