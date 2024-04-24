import 'dart:async';

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
  })  : _crosswordRepository = crosswordRepository,
        _boardInfoRepository = boardInfoRepository,
        super(const CrosswordState()) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
    on<WordUnselected>(_onWordUnselected);
    on<BoardLoadingInformationRequested>(_onBoardLoadingInformationRequested);
  }

  final CrosswordRepository _crosswordRepository;
  final BoardInfoRepository _boardInfoRepository;

  Future<void> _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    final wasAlreadyRequested = state.sections.containsKey(event.position);
    if (wasAlreadyRequested) return;

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
      ),
    );
  }

  void _onWordUnselected(
    WordUnselected event,
    Emitter<CrosswordState> emit,
  ) {
    emit(state.removeSelectedWord());
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
}
