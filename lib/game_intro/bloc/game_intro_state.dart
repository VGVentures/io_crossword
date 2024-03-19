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
    this.solvedWords = 0,
    this.totalWords = 0,
    this.selectedMascot,
  });

  final GameIntroStatus status;
  final bool isIntroCompleted;
  final int solvedWords;
  final int totalWords;
  final Mascots? selectedMascot;

  GameIntroState copyWith({
    GameIntroStatus? status,
    bool? isIntroCompleted,
    int? solvedWords,
    int? totalWords,
    Mascots? selectedMascot,
  }) {
    return GameIntroState(
      status: status ?? this.status,
      isIntroCompleted: isIntroCompleted ?? this.isIntroCompleted,
      solvedWords: solvedWords ?? this.solvedWords,
      totalWords: totalWords ?? this.totalWords,
      selectedMascot: selectedMascot ?? this.selectedMascot,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isIntroCompleted,
        solvedWords,
        totalWords,
        selectedMascot,
      ];
}
