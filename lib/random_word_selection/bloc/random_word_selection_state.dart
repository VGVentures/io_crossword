part of 'random_word_selection_bloc.dart';

enum RandomWordSelectionStatus {
  initial,
  loading,
  initialSuccess,
  success,
  notFound,
  failure,
}

class RandomWordSelectionState extends Equatable {
  const RandomWordSelectionState({
    this.status = RandomWordSelectionStatus.initial,
    this.uncompletedSection,
  });

  final RandomWordSelectionStatus status;
  final BoardSection? uncompletedSection;

  RandomWordSelectionState copyWith({
    RandomWordSelectionStatus? status,
    BoardSection? uncompletedSection,
  }) {
    return RandomWordSelectionState(
      status: status ?? this.status,
      uncompletedSection: uncompletedSection ?? this.uncompletedSection,
    );
  }

  @override
  List<Object?> get props => [status, uncompletedSection];
}
