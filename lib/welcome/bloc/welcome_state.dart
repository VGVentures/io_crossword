part of 'welcome_bloc.dart';

class WelcomeState extends Equatable {
  const WelcomeState({
    required this.solvedWords,
    required this.totalWords,
  });

  /// Creates a [WelcomeState] with the initial status.
  const WelcomeState.initial({
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

  WelcomeState copyWith({
    int? solvedWords,
    int? totalWords,
  }) {
    return WelcomeState(
      solvedWords: solvedWords ?? this.solvedWords,
      totalWords: totalWords ?? this.totalWords,
    );
  }

  @override
  List<Object> get props => [solvedWords, totalWords];
}
