import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc({
    required CrosswordRepository crosswordRepository,
    required BoardInfoRepository boardInfoRepository,
    required CrosswordResource crosswordResource,
  })  : _crosswordRepository = crosswordRepository,
        _boardInfoRepository = boardInfoRepository,
        _crosswordResource = crosswordResource,
        super(const CrosswordState()) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
    on<WordUnselected>(_onWordUnselected);
    on<MascotSelected>(_onMascotSelected);
    on<BoardLoadingInformationRequested>(_onBoardLoadingInformationRequested);
    on<InitialsSelected>(_onInitialsSelected);
    on<AnswerUpdated>(_onAnswerUpdated);
    on<AnswerSubmitted>(_onAnswerSubmitted);
  }

  final CrosswordRepository _crosswordRepository;
  final BoardInfoRepository _boardInfoRepository;
  final CrosswordResource _crosswordResource;

  Future<void> _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    return emit.forEach(
      _crosswordRepository.watchSectionFromPosition(
        event.position.$1,
        event.position.$2,
      ),
      onData: (section) {
        if (section == null) return state;

        final newSectionKey = (section.position.x, section.position.y);

        return state.copyWith(
          status: CrosswordStatus.success,
          sectionSize: section.size,
          sections: {
            ...state.sections,
            newSectionKey: section,
          },
        );
      },
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state.copyWith(
          status: CrosswordStatus.failure,
        );
      },
    );
  }

  (int, int) _findWordInSection(
    CrosswordState state,
    Word word,
    (int, int) section, {
    int attempt = 1,
  }) {
    final sections = state.sections;

    // TODO(Ayad): If it fails because the section is not loaded we
    // should fetch the section
    if (sections[section]!.words.contains(word)) {
      return section;
    }

    // TODO(Ayad): control error handle
    if (attempt >= 3) {
      throw Exception('Word not found in crossword');
    }

    final previousSection = word.axis == Axis.horizontal
        ? (section.$1 - 1, section.$2)
        : (section.$1, section.$2 - 1);

    return _findWordInSection(
      state,
      word,
      previousSection,
      attempt: attempt + 1,
    );
  }

  void _onWordSelected(
    WordSelected event,
    Emitter<CrosswordState> emit,
  ) {
    final section = _findWordInSection(
      state,
      event.word,
      event.section,
    );

    emit(
      state.copyWith(
        selectedWord: WordSelection(
          section: section,
          word: event.word,
        ),
        answer: '',
      ),
    );
  }

  void _onWordUnselected(
    WordUnselected event,
    Emitter<CrosswordState> emit,
  ) {
    emit(state.removeSelectedWord());
  }

  void _onMascotSelected(
    MascotSelected event,
    Emitter<CrosswordState> emit,
  ) {
    emit(state.copyWith(mascot: event.mascot));
  }

  FutureOr<void> _onBoardLoadingInformationRequested(
    BoardLoadingInformationRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    try {
      final zoomLimit = await _boardInfoRepository.getZoomLimit();
      final sectionSize = await _boardInfoRepository.getSectionSize();

      emit(
        state.copyWith(
          zoomLimit: zoomLimit,
          sectionSize: sectionSize,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        const CrosswordState(
          status: CrosswordStatus.failure,
        ),
      );
    }
  }

  void _onInitialsSelected(
    InitialsSelected event,
    Emitter<CrosswordState> emit,
  ) {
    emit(
      state.copyWith(initials: event.initials),
    );
  }

  void _onAnswerUpdated(
    AnswerUpdated event,
    Emitter<CrosswordState> emit,
  ) {
    emit(
      state.copyWith(answer: event.answer),
    );
  }

  Future<void> _onAnswerSubmitted(
    AnswerSubmitted event,
    Emitter<CrosswordState> emit,
  ) async {
    final loadedState = state;
    final selectedWord = loadedState.selectedWord;
    if (selectedWord == null) return;

    final userAnswer = loadedState.answer.toLowerCase();
    final correctAnswer = selectedWord.word.answer.toLowerCase();

    if (userAnswer != correctAnswer) {
      emit(
        loadedState.copyWith(
          selectedWord: selectedWord.copyWith(solvedStatus: WordStatus.invalid),
        ),
      );
      return;
    }

    try {
      final isValidAnswer = await _crosswordResource.answerWord(
        section: loadedState.sections[selectedWord.section]!,
        word: selectedWord.word,
        answer: userAnswer,
        mascot: loadedState.mascot!,
      );

      emit(
        loadedState.copyWith(
          selectedWord: selectedWord.copyWith(
            solvedStatus:
                isValidAnswer ? WordStatus.solved : WordStatus.invalid,
          ),
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      // On answer we don't need to make the page fail complete.
      // This will change in next refactor.
      emit(state.copyWith(status: CrosswordStatus.failure));
    }
  }
}
