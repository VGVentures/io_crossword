import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hint_event.dart';
part 'hint_state.dart';

class HintBloc extends Bloc<HintEvent, HintState> {
  HintBloc() : super(const HintState()) {
    on<HintModeEntered>(_onHintModeEntered);
    on<HintModeExited>(_onHintModeExited);
    on<HintRequested>(_onHintRequested);
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
    emit(const HintState());
  }

  Future<void> _onHintRequested(
    HintRequested event,
    Emitter<HintState> emit,
  ) async {
    emit(state.copyWith(status: HintStatus.thinking));

    // Simulate a delay in retrieving the hint.
    await Future<void>.delayed(const Duration(seconds: 1), () {});

    emit(state.copyWith(status: HintStatus.answered));
  }
}
