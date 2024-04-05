import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc({
    required LeaderboardResource leaderboardResource,
  })  : _leaderboardResource = leaderboardResource,
        super(const LeaderboardState()) {
    on<LoadRequestedLeaderboardEvent>(_onLoad);
  }

  final LeaderboardResource _leaderboardResource;

  Future<void> _onLoad(
    LoadRequestedLeaderboardEvent event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      final players = await _leaderboardResource.getLeaderboardResults();

      if (players.isEmpty) {
        emit(
          state.copyWith(
            status: LeaderboardStatus.empty,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: LeaderboardStatus.success,
          players: players,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: LeaderboardStatus.failure));
    }
  }
}
