part of 'game_intro_bloc.dart';

sealed class GameIntroEvent extends Equatable {
  const GameIntroEvent();
}

class BoardProgressRequested extends GameIntroEvent {
  const BoardProgressRequested();

  @override
  List<Object> get props => [];
}

class WelcomeCompleted extends GameIntroEvent {
  const WelcomeCompleted();

  @override
  List<Object> get props => [];
}

class MascotUpdated extends GameIntroEvent {
  const MascotUpdated(this.mascot);

  final Mascots mascot;

  @override
  List<Object> get props => [mascot];
}

class MascotSubmitted extends GameIntroEvent {
  const MascotSubmitted();

  @override
  List<Object> get props => [];
}

class InitialsUpdated extends GameIntroEvent {
  const InitialsUpdated({required this.character, required this.index});

  final String character;
  final int index;

  @override
  List<Object> get props => [character, index];
}

class InitialsSubmitted extends GameIntroEvent {
  const InitialsSubmitted();

  @override
  List<Object> get props => [];
}
