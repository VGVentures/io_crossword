part of 'game_intro_bloc.dart';

abstract class GameIntroEvent extends Equatable {
  const GameIntroEvent();
}

class GameIntroPlayerCreated extends GameIntroEvent {
  const GameIntroPlayerCreated({
    required this.initials,
    required this.mascot,
  });

  final String initials;
  final Mascots? mascot;

  @override
  List<Object?> get props => [initials, mascot];
}
