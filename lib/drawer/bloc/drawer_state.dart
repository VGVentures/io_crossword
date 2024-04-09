part of 'drawer_bloc.dart';

class DrawerState extends Equatable {
  const DrawerState({
    required this.solvedWords,
    required this.totalWords,
  });

  /// Creates a [DrawerState] with the initial status.
  const DrawerState.initial({
    this.solvedWords = fallbackSolvedWords,
    this.totalWords = fallbackTotalWords,
  });

  @visibleForTesting
  static const fallbackTotalWords = 66666;

  @visibleForTesting
  static const fallbackSolvedWords = 0;

  /// The current amount of solved words in the challenge.
  ///
  /// If the loading of the solved words is yet to be done or fails this will
  /// default to [fallbackSolvedWords].
  final int solvedWords;

  /// The total amount of words to complete the challenge.
  ///
  /// If the loading of the total words is yet to be done or fails this will
  /// default to [fallbackTotalWords].
  final int totalWords;

  DrawerState copyWith({
    int? solvedWords,
    int? totalWords,
  }) {
    return DrawerState(
      solvedWords: solvedWords ?? this.solvedWords,
      totalWords: totalWords ?? this.totalWords,
    );
  }

  @override
  List<Object> get props => [solvedWords, totalWords];
}
