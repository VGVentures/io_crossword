part of 'game_intro_bloc.dart';

enum GameIntroStatus {
  welcome,
  mascotSelection,
  initialsInput,
}

class GameIntroState extends Equatable {
  const GameIntroState({
    this.status = GameIntroStatus.welcome,
    this.selectedMascot = Mascots.dash,
  });

  final GameIntroStatus status;
  final Mascots selectedMascot;

  GameIntroState copyWith({
    GameIntroStatus? status,
    Mascots? selectedMascot,
  }) {
    return GameIntroState(
      status: status ?? this.status,
      selectedMascot: selectedMascot ?? this.selectedMascot,
    );
  }

  @override
  List<Object?> get props => [status, selectedMascot];
}
