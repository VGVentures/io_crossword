part of 'team_selection_cubit.dart';

enum AssetsLoadingStatus {
  inProgress,
  success,
}

class TeamSelectionState extends Equatable {
  const TeamSelectionState({
    this.assetsStatus = AssetsLoadingStatus.inProgress,
    this.index = 0,
  });

  final AssetsLoadingStatus assetsStatus;
  final int index;

  TeamSelectionState copyWith({
    AssetsLoadingStatus? assetsStatus,
    int? index,
  }) {
    return TeamSelectionState(
      assetsStatus: assetsStatus ?? this.assetsStatus,
      index: index ?? this.index,
    );
  }

  @override
  List<Object> get props => [
        assetsStatus,
        index,
      ];
}
