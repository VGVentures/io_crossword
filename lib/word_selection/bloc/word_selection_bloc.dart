import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

part 'word_selection_event.dart';
part 'word_selection_state.dart';

class WordSelectionBloc extends Bloc<WordSelectionEvent, WordSelectionState> {
  WordSelectionBloc({
    required CrosswordResource crosswordResource,
  })  : _crosswordResource = crosswordResource,
        super(const WordSelectionState.initial()) {
    on<SectionSelected>(_onSectionSelected);
    on<LetterSelected>(_onLetterSelected);
    on<WordUnselected>(_onWordUnselected);
    on<WordSolveRequested>(_onWordSolveRequested);
    on<WordSolveAttempted>(_onWordAttemptRequested);
  }

  final CrosswordResource _crosswordResource;

  void _onSectionSelected(
    SectionSelected event,
    Emitter<WordSelectionState> emit,
  ) {
    final section = event.selectedSection;
    final position = (section.position.x, section.position.y);

    final randomWord = section.words.firstWhere(
      (element) => element.solvedTimestamp == null,
    );

    emit(
      WordSelectionState(
        status: WordSelectionStatus.preSolving,
        word: SelectedWord(
          section: position,
          word: randomWord,
        ),
      ),
    );
  }

  /// {@macro letter_selected}
  void _onLetterSelected(
    LetterSelected event,
    Emitter<WordSelectionState> emit,
  ) {
    final horizontalWord = event.letter.words.$1;
    final hasHorizontalWord = horizontalWord != null;

    final verticalWord = event.letter.words.$2;
    final hasVerticalWord = verticalWord != null;

    final currentWord = state.word?.word;

    late final Word newWord;
    if (hasHorizontalWord && currentWord != horizontalWord) {
      newWord = horizontalWord;
    } else if (hasVerticalWord && currentWord != verticalWord) {
      newWord = verticalWord;
    } else {
      newWord = horizontalWord ?? verticalWord!;
    }

    if (newWord == currentWord) return;
    emit(
      state.copyWith(
        status: WordSelectionStatus.preSolving,
        word: SelectedWord(
          section: event.letter.chunkIndex,
          word: newWord,
        ),
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

    if (state.status == WordSelectionStatus.solving ||
        state.status == WordSelectionStatus.solved ||
        state.status == WordSelectionStatus.validating) {
      // Can't solve a word if it's already being solved, solved, or validating.
      return;
    }

    emit(
      state.copyWith(
        status: WordSelectionStatus.solving,
        word: state.word,
      ),
    );
  }

  Future<void> _onWordAttemptRequested(
    WordSolveAttempted event,
    Emitter<WordSelectionState> emit,
  ) async {
    final isSolvingOrIncorrect = state.status == WordSelectionStatus.solving ||
        state.status == WordSelectionStatus.incorrect;
    if (!isSolvingOrIncorrect || state.status == WordSelectionStatus.solved) {
      // Can't solve a word if it's not being solved, has made an incorrect
      // attempt or if it's already solved.
      return;
    }

    emit(
      state.copyWith(status: WordSelectionStatus.validating),
    );

    final points = await _crosswordResource.answerWord(
      wordId: state.word!.word.id,
      answer: event.answer,
    );

    final isCorrect = points > 0;
    if (isCorrect) {
      emit(
        state.copyWith(
          status: WordSelectionStatus.solved,
          word: state.word!.copyWith(
            word: state.word!.word.copyWith(answer: event.answer),
          ),
          wordPoints: points,
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
}
