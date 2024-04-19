part of 'team_selection_cubit.dart';

class TeamSelectionState extends Equatable {
  const TeamSelectionState({
    this.index = 0,
  });

  final int index;

  TeamSelectionState copyWith({
    int? index,
  }) {
    return TeamSelectionState(
      index: index ?? this.index,
    );
  }

  @override
  List<Object> get props => [
        index,
      ];
}
