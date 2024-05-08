import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/cache.dart';
import 'package:flame/flame.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(const LoadingState.initial());

  Future<void> load() async {
    final loadables = [
      () => Flame.images.loadAll(Mascots.dash.teamMascot.loadableAssets()),
      () => Flame.images.loadAll(Mascots.android.teamMascot.loadableAssets()),
      () => Flame.images.loadAll(Mascots.dino.teamMascot.loadableAssets()),
      () => Flame.images.loadAll(Mascots.sparky.teamMascot.loadableAssets()),
    ];

    emit(state.copyWith(assetsCount: loadables.length));

    Flame.images = Images(prefix: '');

    for (final loadable in loadables) {
      await loadable();

      if (!isClosed) {
        emit(state.copyWith(loaded: state.loaded + 1));
      }
    }

    emit(state.copyWith(status: LoadingStatus.loaded));
  }
}
