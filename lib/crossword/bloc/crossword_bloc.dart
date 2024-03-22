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
        super(const CrosswordInitial()) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
    on<WordUnselected>(_onWordUnselected);
    on<RenderModeSwitched>(_onRenderModeSwitched);
    on<MascotSelected>(_onMascotSelected);
    on<BoardLoadingInfoFetched>(_onBoardLoadingInfoFetched);
    on<InitialsSelected>(_onInitialsSelected);
  }

  final CrosswordRepository _crosswordRepository;
  final BoardInfoRepository _boardInfoRepository;

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
        final newSection = {
          (section.position.x, section.position.y): section,
        };

        if (state is CrosswordLoaded) {
          final loadedState = state as CrosswordLoaded;
          return loadedState.copyWith(
            sections: {
              ...loadedState.sections,
              ...newSection,
            },
          );
        }

        return CrosswordLoaded(
          sectionSize: section.size,
          sections: newSection,
        );
      },
    );
  }

  (int, int) _findWordInSection(
    CrosswordLoaded state,
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

  FutureOr<void> _onWordSelected(
    WordSelected event,
    Emitter<CrosswordState> emit,
  ) {
    final currentState = state;
    if (currentState is CrosswordLoaded) {
      final section = _findWordInSection(
        currentState,
        event.word,
        event.section,
      );

      emit(
        currentState.copyWith(
          selectedWord: WordSelection(
            section: section,
            word: event.word,
          ),
        ),
      );
    }
  }

  Future<void> _onWordUnselected(
    WordUnselected event,
    Emitter<CrosswordState> emit,
  ) async {
    if (state is CrosswordLoaded) {
      emit(
        (state as CrosswordLoaded).removeSelectedWord(),
      );
    }
  }

  Future<void> _onRenderModeSwitched(
    RenderModeSwitched event,
    Emitter<CrosswordState> emit,
  ) async {
    if (state is CrosswordLoaded) {
      final loadedState = state as CrosswordLoaded;

      emit(
        loadedState.copyWith(
          renderMode: event.renderMode,
        ),
      );
    }
  }

  Future<void> _onMascotSelected(
    MascotSelected event,
    Emitter<CrosswordState> emit,
  ) async {
    if (state is CrosswordLoaded) {
      emit(
        (state as CrosswordLoaded).copyWith(mascot: event.mascot),
      );
    }
  }

  FutureOr<void> _onBoardLoadingInfoFetched(
    BoardLoadingInfoFetched event,
    Emitter<CrosswordState> emit,
  ) async {
    try {
      final limits = await _boardInfoRepository.getRenderModeZoomLimits();
      final sectionSize = await _boardInfoRepository.getSectionSize();

      if (state is CrosswordLoaded) {
        emit(
          (state as CrosswordLoaded).copyWith(
            renderLimits: limits,
            sectionSize: sectionSize,
          ),
        );
      } else {
        emit(
          CrosswordLoaded(
            sectionSize: sectionSize,
            renderLimits: limits,
          ),
        );
        add(const BoardSectionRequested((0, 0)));
      }
    } catch (e) {
      emit(CrosswordError(e.toString()));
    }
  }

  Future<void> _onInitialsSelected(
    InitialsSelected event,
    Emitter<CrosswordState> emit,
  ) async {
    if (state is CrosswordLoaded) {
      emit(
        (state as CrosswordLoaded).copyWith(initials: event.initials.join()),
      );
    }
  }
}
