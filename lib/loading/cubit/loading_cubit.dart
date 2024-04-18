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
    // Add a pause to slow the transition between screens.
    // await Future<void>.delayed(const Duration(seconds: 1));

    final loadables = [
      () => Flame.images.load(Mascots.dash.teamMascot.idleAnimation.keyName),
      () =>
          Flame.images.load(Mascots.dash.teamMascot.platformAnimation.keyName),
      () => Flame.images.load(Mascots.android.teamMascot.idleAnimation.keyName),
      () => Flame.images
          .load(Mascots.android.teamMascot.platformAnimation.keyName),
      () => Flame.images.load(Mascots.dino.teamMascot.idleAnimation.keyName),
      () =>
          Flame.images.load(Mascots.dino.teamMascot.platformAnimation.keyName),
      () => Flame.images.load(Mascots.sparky.teamMascot.idleAnimation.keyName),
      () => Flame.images
          .load(Mascots.sparky.teamMascot.platformAnimation.keyName),
    ];

    emit(state.copyWith(assetsCount: loadables.length));

    Flame.images = Images(prefix: '');

    for (final loadable in loadables) {
      await loadable();

      if (!isClosed) {
        emit(state.copyWith(loaded: state.loaded + 1));
      }
    }
  }
}
