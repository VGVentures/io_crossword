part of 'game_intro_bloc.dart';

enum GameIntroStatus {
  welcome,
  mascotSelection,
  initialsInput,
}

enum InitialsFormStatus {
  initial,
  loading,
  success,
  invalid,
  failure,
  blacklisted,
}

class GameIntroState extends Equatable {
  const GameIntroState({
    this.status = GameIntroStatus.welcome,
    this.isIntroCompleted = false,
    this.solvedWords = 0,
    this.totalWords = 0,
    this.selectedMascot,
    this.initials = const ['', '', ''],
    this.initialsBlacklist = const [],
    this.initialsStatus = InitialsFormStatus.initial,
  });

  final GameIntroStatus status;
  final bool isIntroCompleted;
  final int solvedWords;
  final int totalWords;
  final Mascots? selectedMascot;
  final List<String> initials;
  final List<String> initialsBlacklist;
  final InitialsFormStatus initialsStatus;

  GameIntroState copyWith({
    GameIntroStatus? status,
    bool? isIntroCompleted,
    int? solvedWords,
    int? totalWords,
    Mascots? selectedMascot,
    List<String>? initials,
    List<String>? initialsBlacklist,
    InitialsFormStatus? initialsStatus,
  }) {
    return GameIntroState(
      status: status ?? this.status,
      isIntroCompleted: isIntroCompleted ?? this.isIntroCompleted,
      solvedWords: solvedWords ?? this.solvedWords,
      totalWords: totalWords ?? this.totalWords,
      selectedMascot: selectedMascot ?? this.selectedMascot,
      initials: initials ?? this.initials,
      initialsBlacklist: initialsBlacklist ?? this.initialsBlacklist,
      initialsStatus: initialsStatus ?? this.initialsStatus,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isIntroCompleted,
        solvedWords,
        totalWords,
        selectedMascot,
        initials,
        initialsBlacklist,
        initialsStatus,
      ];
}
