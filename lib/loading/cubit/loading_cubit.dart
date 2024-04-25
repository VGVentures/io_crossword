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
      () => Flame.images.load(Mascots.dash.teamMascot.idleAnimation.keyName),
      () =>
          Flame.images.load(Mascots.dash.teamMascot.platformAnimation.keyName),
      () => Flame.images.load(Mascots.dash.teamMascot.lookUpAnimation.keyName),
      () => Flame.images.load(Mascots.dash.teamMascot.pickUpAnimation.keyName),
      () => Flame.images.load(Mascots.dash.teamMascot.dangleAnimation.keyName),
      () => Flame.images.load(Mascots.dash.teamMascot.dropInAnimation.keyName),
      () => Flame.images.load(Mascots.android.teamMascot.idleAnimation.keyName),
      () => Flame.images
          .load(Mascots.android.teamMascot.platformAnimation.keyName),
      () =>
          Flame.images.load(Mascots.android.teamMascot.lookUpAnimation.keyName),
      () =>
          Flame.images.load(Mascots.android.teamMascot.pickUpAnimation.keyName),
      () =>
          Flame.images.load(Mascots.android.teamMascot.dangleAnimation.keyName),
      () =>
          Flame.images.load(Mascots.android.teamMascot.dropInAnimation.keyName),
      () => Flame.images.load(Mascots.dino.teamMascot.idleAnimation.keyName),
      () =>
          Flame.images.load(Mascots.dino.teamMascot.platformAnimation.keyName),
      () => Flame.images.load(Mascots.dino.teamMascot.lookUpAnimation.keyName),
      () => Flame.images.load(Mascots.dino.teamMascot.pickUpAnimation.keyName),
      () => Flame.images.load(Mascots.dino.teamMascot.dangleAnimation.keyName),
      () => Flame.images.load(Mascots.dino.teamMascot.dropInAnimation.keyName),
      () => Flame.images.load(Mascots.sparky.teamMascot.idleAnimation.keyName),
      () => Flame.images
          .load(Mascots.sparky.teamMascot.platformAnimation.keyName),
      () =>
          Flame.images.load(Mascots.sparky.teamMascot.lookUpAnimation.keyName),
      () =>
          Flame.images.load(Mascots.sparky.teamMascot.pickUpAnimation.keyName),
      () =>
          Flame.images.load(Mascots.sparky.teamMascot.dangleAnimation.keyName),
      () =>
          Flame.images.load(Mascots.sparky.teamMascot.dropInAnimation.keyName),
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
