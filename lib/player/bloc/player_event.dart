part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
}

class PlayerLoaded extends PlayerEvent {
  const PlayerLoaded({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class PlayerCreateScoreRequested extends PlayerEvent {
  const PlayerCreateScoreRequested(this.userId);

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MascotSelected extends PlayerEvent {
  const MascotSelected(this.mascot);

  final Mascots mascot;

  @override
  List<Object> get props => [mascot];
}

class InitialsSelected extends PlayerEvent {
  const InitialsSelected(this.initials);

  final String initials;

  @override
  List<Object> get props => [initials];
}
