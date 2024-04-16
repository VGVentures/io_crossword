import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'word_selection_event.dart';
part 'word_selection_state.dart';

class WordSelectionBloc extends Bloc<WordSelectionEvent, WordSelectionState> {
  WordSelectionBloc() : super(const WordSelectionState.initial()) {
    on<WordSelected>(_onWordSelected);
    on<WordUnselected>(_onWordUnselected);
    on<WordSolveRequested>(_onWordSolveRequested);
    on<WordFocusedSuccessRequested>(_onWordFocusedSuccessRequested);
    on<WordSolveAttempted>(_onWordAttemptRequested);
  }

  void _onWordSelected(
    WordSelected event,
    Emitter<WordSelectionState> emit,
  ) {
    emit(
      WordSelectionState(
        status: WordSelectionStatus.preSolving,
        word: event.selectedWord,
      ),
    );
  }

  void _onWordUnselected(
    WordUnselected event,
    Emitter<WordSelectionState> emit,
  ) {
    emit(
      const WordSelectionState.initial(),
    );
  }

  void _onWordSolveRequested(
    WordSolveRequested event,
    Emitter<WordSelectionState> emit,
  ) {
    if (state.word == null) {
      // Can't solve a word if no word is selected.
      return;
    }

    emit(
      WordSelectionState(
        status: WordSelectionStatus.solving,
        word: state.word,
      ),
    );
  }

  Future<void> _onWordAttemptRequested(
    WordSolveAttempted event,
    Emitter<WordSelectionState> emit,
  ) async {
    if (state.status != WordSelectionStatus.solving ||
        state.status == WordSelectionStatus.solved) {
      // Can't solve a word if it's not being solved or if it's already solved.
      return;
    }

    emit(
      state.copyWith(status: WordSelectionStatus.validating),
    );

    final isCorrect = await Future.delayed(
      const Duration(seconds: 1),
      // TODO(alesstiago): Replace with a call to the backend that validates
      // the answer.
      // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6444661142
      () => event.answer == 'correct',
    );

    if (isCorrect) {
      emit(
        state.copyWith(
          status: WordSelectionStatus.solved,
          wordPoints: 10,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: WordSelectionStatus.incorrect,
        ),
      );
    }
  }

  void _onWordFocusedSuccessRequested(
    WordFocusedSuccessRequested event,
    Emitter<WordSelectionState> emit,
  ) {
    emit(
      state.copyWith(status: WordSelectionStatus.solved),
    );
  }
}
