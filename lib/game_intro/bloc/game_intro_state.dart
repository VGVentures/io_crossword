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
    this.selectedMascot,
  });

  final GameIntroStatus status;
  final bool isIntroCompleted;
  final Mascots? selectedMascot;

  GameIntroState copyWith({
    GameIntroStatus? status,
    bool? isIntroCompleted,
    Mascots? selectedMascot,
  }) {
    return GameIntroState(
      status: status ?? this.status,
      isIntroCompleted: isIntroCompleted ?? this.isIntroCompleted,
      selectedMascot: selectedMascot ?? this.selectedMascot,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isIntroCompleted,
        selectedMascot,
      ];
}
