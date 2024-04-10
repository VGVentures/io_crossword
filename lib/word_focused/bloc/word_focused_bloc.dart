import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'word_focused_event.dart';
part 'word_focused_state.dart';

class WordFocusedBloc extends Bloc<WordFocusedEvent, WordFocusedState> {
  WordFocusedBloc() : super(const WordFocusedState()) {
    on<WordFocusedSolveRequested>(_onWordFocusedSolveRequested);
    on<WordFocusedSuccessRequested>(_onWordFocusedSuccessRequested);
    on<SolvingFocusSwitched>(_onSolvingFocusSwitched);
  }

  void _onWordFocusedSolveRequested(
    WordFocusedSolveRequested event,
    Emitter<WordFocusedState> emit,
  ) {
    emit(state.copyWith(status: WordFocusedStatus.solving));
  }

  void _onWordFocusedSuccessRequested(
    WordFocusedSuccessRequested event,
    Emitter<WordFocusedState> emit,
  ) {
    emit(state.copyWith(status: WordFocusedStatus.success));
  }

  void _onSolvingFocusSwitched(
    SolvingFocusSwitched event,
    Emitter<WordFocusedState> emit,
  ) {
    if (state.focus == WordSolvingFocus.word) {
      emit(state.copyWith(focus: WordSolvingFocus.hint));
    } else {
      emit(state.copyWith(focus: WordSolvingFocus.word));
    }
  }
}
