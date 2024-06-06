import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/flame.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

part 'how_to_play_state.dart';

class HowToPlayCubit extends Cubit<HowToPlayState> {
  HowToPlayCubit() : super(const HowToPlayState());

  void updateIndex(int index) {
    emit(state.copyWith(index: index));
  }

  void updateStatus(HowToPlayStatus status) {
    emit(state.copyWith(status: status));
  }

  Future<void> loadAssets(Mascot mascot) async {
    emit(
      state.copyWith(
        assetsStatus: AssetsLoadingStatus.inProgress,
      ),
    );

    Flame.images.clearCache();

    if (isMobile()) {
      await Flame.images
          .loadAll(mascot.teamMascot.loadableHowToPlayMobileAssets());
    } else {
      await Flame.images
          .loadAll(mascot.teamMascot.loadableHowToPlayDesktopAssets());
    }

    if (!isClosed) {
      emit(
        state.copyWith(
          assetsStatus: AssetsLoadingStatus.success,
        ),
      );
    }
  }
}
