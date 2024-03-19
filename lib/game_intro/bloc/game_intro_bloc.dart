import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'game_intro_event.dart';
part 'game_intro_state.dart';

class GameIntroBloc extends Bloc<GameIntroEvent, GameIntroState> {
  GameIntroBloc({
    required BoardInfoRepository boardInfoRepository,
  })  : _boardInfoRepository = boardInfoRepository,
        super(const GameIntroState()) {
    _setBlacklist();
    on<BoardProgressRequested>(_onBoardProgressRequested);
    on<WelcomeCompleted>(_onWelcomeCompleted);
    on<MascotUpdated>(_onMascotUpdated);
    on<MascotSubmitted>(_onMascotSubmitted);
    on<InitialsUpdated>(_onInitialsUpdated);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final BoardInfoRepository _boardInfoRepository;
  final initialsRegex = RegExp('[A-Z]{3}');
  late final List<String> blacklist;

  Future<void> _setBlacklist() async {
    // TODO(jaime): fetch blacklist from server
    blacklist = ['TST'];
  }

  Future<void> _onBoardProgressRequested(
    BoardProgressRequested event,
    Emitter<GameIntroState> emit,
  ) async {
    final [solved, total] = await Future.wait([
      _boardInfoRepository.getSolvedWordsCount(),
      _boardInfoRepository.getTotalWordsCount(),
    ]);

    emit(
      state.copyWith(
        solvedWords: solved,
        totalWords: total,
      ),
    );
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
      state.copyWith(status: GameIntroStatus.initialsInput),
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

      // TODO(jaime): createa leaderboard entry for user
      await Future<void>.delayed(const Duration(seconds: 1));

      emit(
        state.copyWith(
          initialsStatus: InitialsFormStatus.success,
          isIntroCompleted: true,
        ),
      );
    }
  }

  bool _hasValidPattern() {
    final value = state.initials;
    return value.isNotEmpty && initialsRegex.hasMatch(value.join());
  }

  bool _isBlacklisted() {
    return blacklist.contains(state.initials.join());
  }
}
