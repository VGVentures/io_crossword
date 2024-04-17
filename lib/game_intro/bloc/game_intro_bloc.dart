import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'game_intro_event.dart';
part 'game_intro_state.dart';

class GameIntroBloc extends Bloc<GameIntroEvent, GameIntroState> {
  GameIntroBloc({
    required LeaderboardResource leaderboardResource,
  })  : _leaderboardResource = leaderboardResource,
        super(const GameIntroState()) {
    on<GameIntroPlayerCreated>(_onGameIntroPlayerCreated);
  }

  final LeaderboardResource _leaderboardResource;

  Future<void> _onGameIntroPlayerCreated(
    GameIntroPlayerCreated event,
    Emitter<GameIntroState> emit,
  ) async {
    try {
      emit(
        const GameIntroState(
          status: GameIntroPlayerCreationStatus.inProgress,
        ),
      );

      await _leaderboardResource.createScore(
        initials: event.initials,
        mascot: event.mascot!,
      );

      emit(
        const GameIntroState(
          status: GameIntroPlayerCreationStatus.success,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        const GameIntroState(
          status: GameIntroPlayerCreationStatus.failure,
        ),
      );
    }
  }
}
