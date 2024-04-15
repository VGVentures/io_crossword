import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc({
    required LeaderboardRepository leaderboardRepository,
  })  : _leaderboardRepository = leaderboardRepository,
        super(const PlayerState()) {
    on<PlayerLoaded>(_onPlayerLoaded);
  }

  final LeaderboardRepository _leaderboardRepository;

  Future<void> _onPlayerLoaded(
    PlayerLoaded event,
    Emitter<PlayerState> emit,
  ) {
    return emit.forEach(
      _leaderboardRepository.getPlayerRanked(event.userId),
      onData: (data) {
        return PlayerState(
          status: PlayerStatus.playing,
          player: data.$1,
          rank: data.$2,
        );
      },
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state.copyWith(
          status: PlayerStatus.failure,
        );
      },
    );
  }
}
