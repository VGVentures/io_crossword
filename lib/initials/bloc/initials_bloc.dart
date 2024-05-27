import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'initials_event.dart';
part 'initials_state.dart';

class InitialsBloc extends Bloc<InitialsEvent, InitialsState> {
  InitialsBloc({
    required LeaderboardResource leaderboardResource,
  })  : _leaderboardResource = leaderboardResource,
        super(InitialsState.initial()) {
    on<InitialsBlocklistRequested>(_onBlocklistRequested);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final LeaderboardResource _leaderboardResource;

  Future<void> _onBlocklistRequested(
    InitialsBlocklistRequested event,
    Emitter<InitialsState> emit,
  ) async {
    final hasBlocklist = state.initials.blocklist != null;
    if (hasBlocklist) return;

    try {
      final blocklist = Blocklist(
        (await _leaderboardResource.getInitialsBlacklist()).toSet(),
      );
      emit(
        state.copyWith(
          initials: state.initials.copyWith(blocklist: blocklist),
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<InitialsState> emit,
  ) async {
    emit(
      state.copyWith(
        initials: InitialsInput.dirty(
          event.initials,
          blocklist: state.initials.blocklist,
        ),
      ),
    );
  }
}
