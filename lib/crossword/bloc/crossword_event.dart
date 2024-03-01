part of 'crossword_bloc.dart';

sealed class CrosswordEvent extends Equatable {
  const CrosswordEvent();
}

class InitialBoardLoadRequested extends CrosswordEvent {
  const InitialBoardLoadRequested();

  @override
  List<Object> get props => [];
}
