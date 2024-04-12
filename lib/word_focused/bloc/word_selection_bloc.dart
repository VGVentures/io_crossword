import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'word_selection_event.dart';
part 'word_selection_state.dart';

class WordSelectionBloc extends Bloc<WordSelectionEvent, WordSelectionState> {
  WordSelectionBloc() : super(const WordSelectionState.initial()) {
    on<WordFocusedSolveRequested>(_onWordFocusedSolveRequested);
    on<WordFocusedSuccessRequested>(_onWordFocusedSuccessRequested);
  }

  void _onWordFocusedSolveRequested(
    WordFocusedSolveRequested event,
    Emitter<WordSelectionState> emit,
  ) {
    emit(
      state.copyWith(status: WordSelectionStatus.solving),
    );
  }

  void _onWordFocusedSuccessRequested(
    WordFocusedSuccessRequested event,
    Emitter<WordSelectionState> emit,
  ) {
    emit(
      state.copyWith(status: WordSelectionStatus.success),
    );
  }
}
