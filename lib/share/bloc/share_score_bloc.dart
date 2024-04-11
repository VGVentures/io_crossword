import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'share_score_event.dart';
part 'share_score_state.dart';

class ShareScoreBloc extends Bloc<ShareScoreEvent, ShareScoreState> {
  ShareScoreBloc() : super(const ShareScoreState()) {
    on<ShareScoreSolveRequested>(_onShareScoreSolveRequested);
    on<ShareScoreSuccessRequested>(_onShareScoreSuccessRequested);
    on<SolvingFocusSwitched>(_onSolvingFocusSwitched);
  }

  void _onShareScoreSolveRequested(
    ShareScoreSolveRequested event,
    Emitter<ShareScoreState> emit,
  ) {
    emit(state.copyWith(status: ShareScoreStatus.solving));
  }

  void _onShareScoreSuccessRequested(
    ShareScoreSuccessRequested event,
    Emitter<ShareScoreState> emit,
  ) {
    emit(state.copyWith(status: ShareScoreStatus.success));
  }

  void _onSolvingFocusSwitched(
    SolvingFocusSwitched event,
    Emitter<ShareScoreState> emit,
  ) {
    if (state.focus == WordSolvingFocus.word) {
      emit(state.copyWith(focus: WordSolvingFocus.hint));
    } else {
      emit(state.copyWith(focus: WordSolvingFocus.word));
    }
  }
}
