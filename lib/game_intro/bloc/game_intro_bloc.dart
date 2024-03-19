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
    on<BoardProgressRequested>(_onBoardProgressRequested);
    on<WelcomeCompleted>(_onWelcomeCompleted);
    on<MascotUpdated>(_onMascotUpdated);
    on<MascotSubmitted>(_onMascotSubmitted);
    on<InitialsUpdated>(_onInitialsUpdated);
    on<InitialsSubmitted>(_onInitialsSubmitted);
  }

  final BoardInfoRepository _boardInfoRepository;

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

  void _onInitialsSubmitted(
    InitialsSubmitted event,
    Emitter<GameIntroState> emit,
  ) {
    emit(
      state.copyWith(isIntroCompleted: true),
    );
  }
}
