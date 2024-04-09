import 'dart:collection';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'initials_event.dart';
part 'initials_state.dart';

class InitialsBloc extends Bloc<InitialsEvent, InitialsState> {
  InitialsBloc({
    required LeaderboardResource leaderboardResource,
  })  : _leaderboardResource = leaderboardResource,
        super(InitialsState.initial()) {
    on<InitialsBlocklistRequested>(_onBlocklistRequested);
    on<InitialsChanged>(_onInitialsChanged);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final LeaderboardResource _leaderboardResource;

  void _onBlocklistRequested(
    InitialsBlocklistRequested event,
    Emitter<InitialsState> emit,
  ) async {
    try {
      emit(state.copyWith(status: InitialsStatus.loading));
      final blocklist = await _leaderboardResource.getInitialsBlacklist();
      emit(
        state.copyWith(
          status: InitialsStatus.success,
          initials: InitialsInput.pure(
            blocklist: UnmodifiableSetView(Set.from(blocklist)),
          ),
        ),
      );
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: InitialsStatus.failure));
    }
  }

  void _onInitialsChanged(
    InitialsChanged event,
    Emitter<InitialsState> emit,
  ) {
    final initials = state.initials;
    if (initials == null) return;

    emit(
      state.copyWith(
        initials: InitialsInput.dirty(
          event.initials,
          blocklist: initials.blocklist,
        ),
      ),
    );
  }

  void _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<InitialsState> emit,
  ) {
    final initials = state.initials;
    if (initials == null) return;
  }
}
