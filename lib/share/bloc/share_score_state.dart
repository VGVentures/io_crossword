part of 'share_score_bloc.dart';

enum ShareScoreStatus {
  clue,
  solving,
  success,
}

enum WordSolvingFocus { word, hint }

class ShareScoreState extends Equatable {
  const ShareScoreState({
    this.status = ShareScoreStatus.clue,
    this.focus = WordSolvingFocus.word,
  });

  final ShareScoreStatus status;
  final WordSolvingFocus focus;

  ShareScoreState copyWith({
    ShareScoreStatus? status,
    WordSolvingFocus? focus,
  }) {
    return ShareScoreState(
      status: status ?? this.status,
      focus: focus ?? this.focus,
    );
  }

  @override
  List<Object?> get props => [status, focus];
}
