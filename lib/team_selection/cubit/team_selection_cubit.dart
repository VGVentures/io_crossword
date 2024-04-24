import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'team_selection_state.dart';

class TeamSelectionCubit extends Cubit<TeamSelectionState> {
  TeamSelectionCubit() : super(const TeamSelectionState());

  void selectTeam(int teamIndex) {
    emit(state.copyWith(index: teamIndex));
  }
}
