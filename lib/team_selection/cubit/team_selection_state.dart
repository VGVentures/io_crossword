part of 'team_selection_cubit.dart';

enum TeamSelectionStatus {
  loading,

  loadingComplete,
}

class TeamSelectionState extends Equatable {
  const TeamSelectionState({
    this.status = TeamSelectionStatus.loading,
    this.index = 0,
  });

  final TeamSelectionStatus status;

  final int index;

  TeamSelectionState copyWith({
    TeamSelectionStatus? status,
    int? index,
  }) {
    return TeamSelectionState(
      status: status ?? this.status,
      index: index ?? this.index,
    );
  }

  @override
  List<Object> get props => [
        status,
        index,
      ];
}
