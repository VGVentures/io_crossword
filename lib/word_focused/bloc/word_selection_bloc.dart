import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'word_selection_event.dart';

enum WordSelectionState {
  clue,
  solving,
  success,
}

class WordSelectionBloc extends Bloc<WordSelectionEvent, WordSelectionState> {
  WordSelectionBloc() : super(WordSelectionState.clue) {
    on<WordFocusedSolveRequested>(_onWordFocusedSolveRequested);
    on<WordFocusedSuccessRequested>(_onWordFocusedSuccessRequested);
  }

  void _onWordFocusedSolveRequested(
    WordFocusedSolveRequested event,
    Emitter<WordSelectionState> emit,
  ) {
    emit(WordSelectionState.solving);
  }

  void _onWordFocusedSuccessRequested(
    WordFocusedSuccessRequested event,
    Emitter<WordSelectionState> emit,
  ) {
    emit(WordSelectionState.success);
  }
}
