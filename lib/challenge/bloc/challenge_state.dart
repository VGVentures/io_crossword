part of 'challenge_bloc.dart';

class ChallengeState extends Equatable {
  const ChallengeState({
    required this.solvedWords,
    required this.totalWords,
  });

  /// Creates a [ChallengeState] with the initial status.
  const ChallengeState.initial({
    this.solvedWords = fallbackSolvedWords,
    this.totalWords = fallbackTotalWords,
  });

  @visibleForTesting
  static const fallbackTotalWords = 66666;

  @visibleForTesting
  static const fallbackSolvedWords = 0;

  /// The current solved words in the challenge.
  ///
  /// If the loading of the solved words is yet to be done or fails this will
  /// default to [fallbackSolvedWords].
  final int solvedWords;

  /// The total words to complete the challenge.
  ///
  /// If the loading of the total words is yet to be done or fails this will
  /// default to [fallbackTotalWords].
  final int totalWords;

  ChallengeState copyWith({
    int? solvedWords,
    int? totalWords,
  }) {
    return ChallengeState(
      solvedWords: solvedWords ?? this.solvedWords,
      totalWords: totalWords ?? this.totalWords,
    );
  }

  @override
  List<Object> get props => [solvedWords, totalWords];
}
