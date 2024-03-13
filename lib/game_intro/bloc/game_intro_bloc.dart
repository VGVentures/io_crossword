import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_intro_event.dart';
part 'game_intro_state.dart';

class GameIntroBloc extends Bloc<GameIntroEvent, GameIntroState> {
  GameIntroBloc() : super(const GameIntroState()) {
    on<WelcomeCompleted>(_onWelcomeCompleted);
    on<MascotSubmitted>(_onMascotSubmitted);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  void _onWelcomeCompleted(
    WelcomeCompleted event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(status: GameIntroStatus.mascotSelection),
    );
  }

  void _onMascotSubmitted(
    MascotSubmitted event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(status: GameIntroStatus.initialsInput),
    );
  }

  void _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(isIntroCompleted: true),
    );
  }
}
