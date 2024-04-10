import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'game_intro_event.dart';
part 'game_intro_state.dart';

class GameIntroBloc extends Bloc<GameIntroEvent, GameIntroState> {
  GameIntroBloc() : super(const GameIntroState()) {
    on<MascotUpdated>(_onMascotUpdated);
    on<MascotSubmitted>(_onMascotSubmitted);
  }

  void _onMascotUpdated(
    MascotUpdated event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(selectedMascot: event.mascot),
    );
  }

  void _onMascotSubmitted(
    MascotSubmitted event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(
        selectedMascot: state.selectedMascot,
        status: GameIntroStatus.initialsInput,
      ),
    );
  }
}
