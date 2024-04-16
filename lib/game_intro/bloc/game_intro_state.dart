part of 'game_intro_bloc.dart';

enum GameIntroPlayerCreationStatus {
  initial,
  inProgress,
  success,
  failure,
}

class GameIntroState extends Equatable {
  const GameIntroState({
    this.status = GameIntroPlayerCreationStatus.initial,
  });

  final GameIntroPlayerCreationStatus status;

  @override
  List<Object?> get props => [status];
}
