import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'hint_event.dart';
part 'hint_state.dart';

class HintBloc extends Bloc<HintEvent, HintState> {
  HintBloc({
    required HintResource hintResource,
    required BoardInfoRepository boardInfoRepository,
  })  : _hintResource = hintResource,
        _boardInfoRepository = boardInfoRepository,
        super(const HintState()) {
    on<HintEnabledRequested>(_onHintEnabledRequested);
    on<HintModeEntered>(_onHintModeEntered);
    on<HintModeExited>(_onHintModeExited);
    on<HintRequested>(_onHintRequested);
    on<PreviousHintsRequested>(_onPreviousHintsRequested);
  }

  final HintResource _hintResource;
  final BoardInfoRepository _boardInfoRepository;

  Future<void> _onHintEnabledRequested(
    HintEnabledRequested event,
    Emitter<HintState> emit,
  ) async {
    await emit.forEach(
      _boardInfoRepository.isHintsEnabled(),
      onData: (isHintsEnabled) {
        return state.copyWith(isHintsEnabled: isHintsEnabled);
      },
    );
  }

  void _onHintModeEntered(
    HintModeEntered event,
    Emitter<HintState> emit,
  ) {
    emit(state.copyWith(status: HintStatus.asking));
  }

  void _onHintModeExited(
    HintModeExited event,
    Emitter<HintState> emit,
  ) {
    emit(state.copyWith(status: HintStatus.initial));
  }

  Future<void> _onHintRequested(
    HintRequested event,
    Emitter<HintState> emit,
  ) async {
    if (state.hintsLeft <= 0) return;

    emit(state.copyWith(status: HintStatus.thinking));

    final (hint, maxHints) = await _hintResource.generateHint(
      wordId: event.wordId,
      question: event.question,
    );
    final allHints = [...state.hints, hint];

    emit(
      state.copyWith(
        status: HintStatus.answered,
        hints: allHints,
        maxHints: maxHints,
      ),
    );
  }

  Future<void> _onPreviousHintsRequested(
    PreviousHintsRequested event,
    Emitter<HintState> emit,
  ) async {
    if (state.hints.isEmpty) {
      final (hints, maxHints) =
          await _hintResource.getHints(wordId: event.wordId);
      emit(
        state.copyWith(
          hints: hints,
          maxHints: maxHints,
        ),
      );
    }
  }
}
