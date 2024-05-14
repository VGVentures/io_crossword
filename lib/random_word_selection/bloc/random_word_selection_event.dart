part of 'random_word_selection_bloc.dart';

abstract class RandomWordSelectionEvent extends Equatable {
  const RandomWordSelectionEvent();
}

class RandomWordInitialRequested extends RandomWordSelectionEvent {
  const RandomWordInitialRequested();

  @override
  List<Object?> get props => [];
}

class RandomWordRequested extends RandomWordSelectionEvent {
  const RandomWordRequested();

  @override
  List<Object?> get props => [];
}
