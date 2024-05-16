part of 'crossword_bloc.dart';

sealed class CrosswordEvent extends Equatable {
  const CrosswordEvent();
}

class BoardLoadingInformationRequested extends CrosswordEvent {
  const BoardLoadingInformationRequested();

  @override
  List<Object?> get props => [];
}

class GameStatusRequested extends CrosswordEvent {
  const GameStatusRequested();

  @override
  List<Object?> get props => [];
}

class BoardStatusResumed extends CrosswordEvent {
  const BoardStatusResumed();

  @override
  List<Object?> get props => [];
}

class MascotDropped extends CrosswordEvent {
  const MascotDropped();

  @override
  List<Object?> get props => [];
}

class CrosswordSectionsLoaded extends CrosswordEvent {
  const CrosswordSectionsLoaded(this.selectedWord);

  final SelectedWord selectedWord;

  @override
  List<Object> get props => [selectedWord];
}
