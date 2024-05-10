import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/flame.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

part 'team_selection_state.dart';

class TeamSelectionCubit extends Cubit<TeamSelectionState> {
  TeamSelectionCubit() : super(const TeamSelectionState());

  void selectTeam(int teamIndex) {
    emit(state.copyWith(index: teamIndex));
  }

  Future<void> loadAssets() async {
    emit(
      state.copyWith(
        assetsStatus: AssetsLoadingStatus.inProgress,
      ),
    );

    Flame.images.clearCache();

    await Flame.images.loadAll([
      ...Mascots.dash.teamMascot.loadableTeamSelectionAssets(),
      ...Mascots.sparky.teamMascot.loadableTeamSelectionAssets(),
      ...Mascots.android.teamMascot.loadableTeamSelectionAssets(),
      ...Mascots.dino.teamMascot.loadableTeamSelectionAssets(),
    ]);

    emit(
      state.copyWith(
        assetsStatus: AssetsLoadingStatus.success,
      ),
    );
  }
}
