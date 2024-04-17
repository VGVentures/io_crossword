import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/flame.dart';
import 'package:game_domain/game_domain.dart';

part 'team_selection_state.dart';

class TeamSelectionCubit extends Cubit<TeamSelectionState> {
  TeamSelectionCubit() : super(const TeamSelectionState());

  Future<void> load() async {
    emit(state.copyWith(status: TeamSelectionStatus.loading));
    await Flame.images.loadAll([
      Mascots.dash.idleAnimation,
      Mascots.dash.platformAnimation,
      Mascots.android.idleAnimation,
      Mascots.android.platformAnimation,
      Mascots.sparky.idleAnimation,
      Mascots.sparky.platformAnimation,
      Mascots.dino.idleAnimation,
      Mascots.dino.platformAnimation,
    ]);

    if (!isClosed) {
      emit(state.copyWith(status: TeamSelectionStatus.loadingComplete));
    }
  }

  void selectTeam(int teamIndex) {
    emit(state.copyWith(index: teamIndex));
  }
}
