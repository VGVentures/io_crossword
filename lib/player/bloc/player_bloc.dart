import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc({
    required LeaderboardResource leaderboardResource,
    required LeaderboardRepository leaderboardRepository,
  })  : _leaderboardRepository = leaderboardRepository,
        _leaderboardResource = leaderboardResource,
        super(const PlayerState()) {
    on<InitialsSelected>(_onInitialsSelected);
    on<MascotSelected>(_onMascotSelected);
    on<PlayerLoaded>(_onPlayerLoaded);
    on<PlayerCreateScoreRequested>(_playerCreateScoreRequested);
  }

  final LeaderboardRepository _leaderboardRepository;
  final LeaderboardResource _leaderboardResource;

  Future<void> _playerCreateScoreRequested(
    PlayerCreateScoreRequested event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.status == PlayerStatus.loading) {
      // A player score has been created or is being created, don't create
      // another one.
      return;
    }

    if (state.player.initials.isEmpty) {
      // There is no initials selected, hence we can't create a player score.
      return;
    }

    emit(state.copyWith(status: PlayerStatus.loading));

    try {
      await _leaderboardResource.createScore(
        initials: state.player.initials,
        mascot: state.mascot,
      );

      final (player, rank) =
          await _leaderboardRepository.getPlayerRanked(event.userId).first;

      emit(
        state.copyWith(
          status: PlayerStatus.playing,
          player: player,
          rank: rank,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: PlayerStatus.failure));
    }
  }

  Future<void> _onPlayerLoaded(
    PlayerLoaded event,
    Emitter<PlayerState> emit,
  ) {
    return emit.forEach(
      _leaderboardRepository.getPlayerRanked(event.userId),
      onData: (data) {
        if (data.$1 == Player.empty) {
          return state;
        }

        return state.copyWith(
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

  void _onMascotSelected(
    MascotSelected event,
    Emitter<PlayerState> emit,
  ) {
    emit(
      state.copyWith(
        mascot: event.mascot,
        player: state.player.copyWith(
          mascot: event.mascot,
        ),
      ),
    );
  }

  void _onInitialsSelected(
    InitialsSelected event,
    Emitter<PlayerState> emit,
  ) {
    emit(
      state.copyWith(
        player: state.player.copyWith(
          initials: event.initials,
        ),
      ),
    );
  }
}
