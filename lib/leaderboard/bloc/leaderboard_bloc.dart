import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc({
    required LeaderboardResource leaderboardResource,
    required LeaderboardRepository leaderboardRepository,
  })  : _leaderboardResource = leaderboardResource,
        _leaderboardRepository = leaderboardRepository,
        super(const LeaderboardState()) {
    on<LoadRequestedLeaderboardEvent>(_onLoadRequested);
  }

  final LeaderboardResource _leaderboardResource;
  final LeaderboardRepository _leaderboardRepository;

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

      final foundCurrentUser =
          players.where((player) => player.userId == event.userId);

      // In this case we don't need to search for the player position
      // because its in top 10 leaderboard.
      if (foundCurrentUser.isNotEmpty) {
        final player = foundCurrentUser.first;

        emit(
          state.copyWith(
            status: LeaderboardStatus.success,
            players: players,
          ),
        );

        // We want to update the users ranking to show the latest position.
        // TODO(any): This can be moved to the repository adding the top 10
        // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6444902861
        _leaderboardRepository.updateUsersRankingPosition(
          players.indexOf(player) + 1,
        );
      } else {
        return emit.forEach(
          _leaderboardRepository.getPlayerRanked(event.userId),
          onData: (data) {
            return state.copyWith(
              currentPlayer: data.$1,
              currentUserPosition: data.$2,
              status: LeaderboardStatus.success,
              players: players,
            );
          },
          onError: (error, stackTrace) {
            addError(error, stackTrace);
            return state.copyWith(
              status: LeaderboardStatus.failure,
            );
          },
        );
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: LeaderboardStatus.failure));
    }
  }
}
