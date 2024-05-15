part of 'random_word_selection_bloc.dart';

abstract class RandomWordSelectionEvent extends Equatable {
  const RandomWordSelectionEvent();
}

class RandomWordRequested extends RandomWordSelectionEvent {
  const RandomWordRequested({this.isInitial = false});

  final bool isInitial;

  @override
  List<Object?> get props => [isInitial];
}
