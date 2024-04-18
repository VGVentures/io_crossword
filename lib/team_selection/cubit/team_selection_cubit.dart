import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

part 'team_selection_state.dart';

class TeamSelectionCubit extends Cubit<TeamSelectionState> {
  TeamSelectionCubit() : super(const TeamSelectionState());

  Future<void> load() async {
    emit(state.copyWith(status: TeamSelectionStatus.loading));
    Flame.images = Images(prefix: '');
    await Flame.images.loadAll([
      Mascots.dash.teamMascot.idleAnimation.keyName,
      Mascots.dash.teamMascot.platformAnimation.keyName,
      Mascots.android.teamMascot.idleAnimation.keyName,
      Mascots.android.teamMascot.platformAnimation.keyName,
      Mascots.dino.teamMascot.idleAnimation.keyName,
      Mascots.dino.teamMascot.platformAnimation.keyName,
      Mascots.sparky.teamMascot.idleAnimation.keyName,
      Mascots.sparky.teamMascot.platformAnimation.keyName,
    ]);

    if (!isClosed) {
      emit(state.copyWith(status: TeamSelectionStatus.loadingComplete));
    }
  }

  void selectTeam(int teamIndex) {
    emit(state.copyWith(index: teamIndex));
  }
}
