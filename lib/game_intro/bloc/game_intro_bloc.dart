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
    on<BlacklistRequested>(_onBlacklistRequested);
    on<WelcomeCompleted>(_onWelcomeCompleted);
    on<MascotUpdated>(_onMascotUpdated);
    on<MascotSubmitted>(_onMascotSubmitted);
    on<InitialsUpdated>(_onInitialsUpdated);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final LeaderboardResource _leaderboardResource;
  final initialsRegex = RegExp('[A-Z]{3}');

  Future<void> _onBlacklistRequested(
    BlacklistRequested event,
    Emitter<GameIntroState> emit,
  ) async {
    try {
      final blacklist = await _leaderboardResource.getInitialsBlacklist();
      emit(state.copyWith(initialsBlacklist: blacklist));
    } catch (e, s) {
      addError(e, s);
    }
  }

  void _onWelcomeCompleted(
    WelcomeCompleted event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(status: GameIntroStatus.mascotSelection),
    );
  }

  void _onMascotUpdated(
    MascotUpdated event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(selectedMascot: event.mascot),
    );
  }

  void _onMascotSubmitted(
    MascotSubmitted event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(
        selectedMascot: state.selectedMascot,
        status: GameIntroStatus.initialsInput,
      ),
    );
  }

  void _onInitialsUpdated(
    InitialsUpdated event,
    Emitter<GameIntroState> emit,
  ) {
    final initials = [...state.initials];
    initials[event.index] = event.character;
    final initialsStatus =
        (state.initialsStatus == InitialsFormStatus.blacklisted)
            ? InitialsFormStatus.initial
            : state.initialsStatus;
    emit(state.copyWith(initials: initials, initialsStatus: initialsStatus));
  }

  Future<void> _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<GameIntroState> emit,
  ) async {
    if (!_hasValidPattern()) {
      emit(state.copyWith(initialsStatus: InitialsFormStatus.invalid));
    } else if (_isBlacklisted()) {
      emit(state.copyWith(initialsStatus: InitialsFormStatus.blacklisted));
    } else {
      emit(state.copyWith(initialsStatus: InitialsFormStatus.loading));

      try {
        await _leaderboardResource.createScore(
          initials: state.initials.join(),
          mascot: state.selectedMascot,
        );

        emit(
          state.copyWith(
            initialsStatus: InitialsFormStatus.success,
            isIntroCompleted: true,
          ),
        );
      } catch (e, s) {
        addError(e, s);
        emit(state.copyWith(initialsStatus: InitialsFormStatus.failure));
      }
    }
  }

  bool _hasValidPattern() {
    final value = state.initials;
    return value.isNotEmpty && initialsRegex.hasMatch(value.join());
  }

  bool _isBlacklisted() {
    return state.initialsBlacklist.contains(state.initials.join());
  }
}
