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
