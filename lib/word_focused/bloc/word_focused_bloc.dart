import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'word_focused_event.dart';

enum WordFocusedState {
  clue,
  solving,
  success,
}

class WordFocusedBloc extends Bloc<WordFocusedEvent, WordFocusedState> {
  WordFocusedBloc() : super(WordFocusedState.clue) {
    on<WordFocusedSolveRequested>(_onWordFocusedSolveRequested);
    on<WordFocusedSuccessRequested>(_onWordFocusedSuccessRequested);
  }

  void _onWordFocusedSolveRequested(
    WordFocusedSolveRequested event,
    Emitter<WordFocusedState> emit,
  ) {
    emit(WordFocusedState.solving);
  }

  void _onWordFocusedSuccessRequested(
    WordFocusedSuccessRequested event,
    Emitter<WordFocusedState> emit,
  ) {
    emit(WordFocusedState.success);
  }
}
