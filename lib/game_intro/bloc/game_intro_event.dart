part of 'game_intro_bloc.dart';

sealed class GameIntroEvent extends Equatable {
  const GameIntroEvent();
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

class InitialsSubmitted extends GameIntroEvent {
  const InitialsSubmitted();

  @override
  List<Object> get props => [];
}
