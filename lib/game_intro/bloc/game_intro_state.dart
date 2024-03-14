part of 'game_intro_bloc.dart';

enum GameIntroStatus {
  welcome,
  mascotSelection,
  initialsInput,
}

class GameIntroState extends Equatable {
  const GameIntroState({
    this.status = GameIntroStatus.welcome,
    this.isIntroCompleted = false,
  });

  final GameIntroStatus status;
  final bool isIntroCompleted;

  GameIntroState copyWith({
    GameIntroStatus? status,
    bool? isIntroCompleted,
  }) {
    return GameIntroState(
      status: status ?? this.status,
      isIntroCompleted: isIntroCompleted ?? this.isIntroCompleted,
    );
  }

  @override
  List<Object> get props => [status, isIntroCompleted];
}
