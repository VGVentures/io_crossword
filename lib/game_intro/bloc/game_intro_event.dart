part of 'game_intro_bloc.dart';

sealed class GameIntroEvent extends Equatable {
  const GameIntroEvent();
}

class MascotUpdated extends GameIntroEvent {
  const MascotUpdated(this.mascot);

  final Mascots mascot;

  @override
  List<Object> get props => [mascot];
}

class MascotSubmitted extends GameIntroEvent {
  const MascotSubmitted(this.mascot);

  final Mascots mascot;

  @override
  List<Object> get props => [mascot];
}
