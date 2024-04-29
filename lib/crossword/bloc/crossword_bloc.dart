import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

typedef SubscriptionsMap
    = Map<CrosswordChunkIndex, StreamSubscription<BoardSection?>>;

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc({
    required CrosswordRepository crosswordRepository,
    required BoardInfoRepository boardInfoRepository,
    @visibleForTesting SubscriptionsMap? subscriptionsMap,
  })  : _crosswordRepository = crosswordRepository,
        _boardInfoRepository = boardInfoRepository,
        subscriptions = subscriptionsMap ?? {},
        super(const CrosswordState()) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
    on<WordUnselected>(_onWordUnselected);
    on<BoardLoadingInformationRequested>(_onBoardLoadingInformationRequested);
    on<VisibleSectionsCleaned>(_onVisibleSectionsCleaned);
    on<BoardSectionLoaded>(_onBoardSectionLoaded);
  }

  final CrosswordRepository _crosswordRepository;
  final BoardInfoRepository _boardInfoRepository;

  final SubscriptionsMap subscriptions;

  void _onVisibleSectionsCleaned(
    VisibleSectionsCleaned event,
    Emitter<CrosswordState> emit,
  ) {
    for (final key in subscriptions.keys) {
      if (!event.visibleSections.contains(key)) {
        subscriptions[key]?.pause();
      }
    }
  }

  @override
  Future<void> close() {
    for (final sub in subscriptions.values) {
      sub.cancel();
    }
    return super.close();
  }

  void _onBoardSectionLoaded(
    BoardSectionLoaded event,
    Emitter<CrosswordState> emit,
  ) {
    final newSectionKey = (event.section.position.x, event.section.position.y);
    final sections = {...state.sections};
    sections[newSectionKey] = event.section;
    emit(
      state.copyWith(
        status: CrosswordStatus.success,
        sectionSize: event.section.size,
        sections: sections,
      ),
    );
  }

  void _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) {
    final index = (event.position.$1, event.position.$2);

    if (subscriptions[index] != null) {
      if (subscriptions[index]!.isPaused) {
        subscriptions[index]!.resume();
      }
    } else {
      subscriptions[index] = _crosswordRepository
          .watchSectionFromPosition(index.$1, index.$2)
          .listen(
        (section) {
          if (section == null) return;

          add(BoardSectionLoaded(section));
        },
        onError: (Object error, StackTrace stackTrace) {
          addError(error, stackTrace);
          emit(
            state.copyWith(
              status: CrosswordStatus.failure,
            ),
          );
        },
      );
    }
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
