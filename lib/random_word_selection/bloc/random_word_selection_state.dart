part of 'random_word_selection_bloc.dart';

enum RandomWordSelectionStatus {
  initial,
  loading,
  initialSuccess,
  success,
  notFound,
  initialNotFound,
  failure,
}

class RandomWordSelectionState extends Equatable {
  const RandomWordSelectionState({
    this.status = RandomWordSelectionStatus.initial,
    this.randomWord,
    this.sectionPosition,
  });

  final RandomWordSelectionStatus status;
  final Word? randomWord;
  final (int, int)? sectionPosition;

  RandomWordSelectionState copyWith({
    RandomWordSelectionStatus? status,
    Word? randomWord,
    (int, int)? sectionPosition,
  }) {
    return RandomWordSelectionState(
      status: status ?? this.status,
      randomWord: randomWord ?? this.randomWord,
      sectionPosition: sectionPosition ?? this.sectionPosition,
    );
  }

  @override
  List<Object?> get props => [status, randomWord, sectionPosition];
}
