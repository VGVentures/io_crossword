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
    on<InitialsBlocklistRequested>((_, emit) => _onBlocklistRequested(emit));
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final LeaderboardResource _leaderboardResource;

  Future<void> _onBlocklistRequested(Emitter<InitialsState> emit) async {
    try {
      final blocklist = Blocklist(
        (await _leaderboardResource.getInitialsBlacklist()).toSet(),
      );
      emit(
        state.copyWith(
          initials: state.initials.copyWith(blocklist: blocklist),
        ),
      );
    } catch (e, s) {
      addError(e, s);
    }
  }

  Future<void> _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<InitialsState> emit,
  ) async {
    final initials = InitialsInput.dirty(
      event.initials,
      blocklist: state.initials.blocklist,
    );

    emit(
      state.copyWith(
        status: InitialsStatus.loading,
        initials: initials,
      ),
    );

    if (initials.blocklist == null) {
      await _onBlocklistRequested(emit);
      if (initials.blocklist == null) {
        emit(state.copyWith(status: InitialsStatus.failure));
        return;
      }
    }

    final error = initials.validator(event.initials);
    if (error != null) {
      emit(state.copyWith(status: InitialsStatus.failure));
      return;
    }

    emit(
      state.copyWith(status: InitialsStatus.success),
    );
  }

  @override
  void onTransition(Transition<InitialsEvent, InitialsState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
