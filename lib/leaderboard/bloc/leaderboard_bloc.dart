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
    on<LoadRequestedLeaderboardEvent>(_onLoadRequested);
  }

  final LeaderboardResource _leaderboardResource;

  Future<void> _onLoadRequested(
    LoadRequestedLeaderboardEvent event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      final players = await _leaderboardResource.getLeaderboardResults();

      // If empty we display 10 users with score 0.
      if (players.isEmpty) {
        emit(
          state.copyWith(
            status: LeaderboardStatus.success,
            players: List.generate(
              10,
              (index) => const LeaderboardPlayer(
                userId: '',
                initials: 'AAA',
                score: 0,
                streak: 0,
                mascot: Mascots.dash,
              ),
            ),
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
