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

/// Signature of the Map that holds the subscriptions for each chunk.
///
/// See also:
///
/// * [CrosswordBloc._subscriptions], the map that holds the subscriptions.
typedef SubscriptionsMap
    = Map<CrosswordChunkIndex, StreamSubscription<BoardSection?>>;

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc({
    required CrosswordRepository crosswordRepository,
    required BoardInfoRepository boardInfoRepository,
    @visibleForTesting SubscriptionsMap? subscriptionsMap,
  })  : _crosswordRepository = crosswordRepository,
        _boardInfoRepository = boardInfoRepository,
        _subscriptions = subscriptionsMap ?? {},
        super(const CrosswordState()) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
    on<WordUnselected>(_onWordUnselected);
    on<BoardLoadingInformationRequested>(_onBoardLoadingInformationRequested);
    on<LoadedSectionsSuspended>(_onLoadedSectionsSuspended);
    on<BoardSectionLoaded>(_onBoardSectionLoaded);
    on<GameStatusRequested>(_onGameStatusRequested);
    on<BoardStatusResumed>(_onBoardStatusResumed);
    on<MascotDropped>(_onMascotDropped);
  }

  final CrosswordRepository _crosswordRepository;
  final BoardInfoRepository _boardInfoRepository;

  /// Holds the subscriptions for each chunk.
  ///
  /// Originally, the map is empty. As chunks get loaded the key is the index of
  /// the chunk and the value is the subscription to the stream of the chunk.
  ///
  /// Whenever a chunk is not visible, the subscription is not cancelled or
  /// removed, but paused, until it is visible again.
  ///
  /// Once the [CrosswordBloc] is [close]ed all subscriptions are canceled.
  final SubscriptionsMap _subscriptions;

  Future<void> _onLoadedSectionsSuspended(
    LoadedSectionsSuspended event,
    Emitter<CrosswordState> emit,
  ) async {
    for (final entry in _subscriptions.entries) {
      if (!event.loadedSections.contains(entry.key) && !entry.value.isPaused) {
        entry.value.pause();
      }
    }
  }

  @override
  Future<void> close() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();

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

    if (_subscriptions[index] != null) {
      if (_subscriptions[index]!.isPaused) {
        _subscriptions[index]!.resume();
      }
    } else {
      _subscriptions[index] = _crosswordRepository
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
    emit(state.copyWith(mascotVisible: true));

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

  Future<void> _onGameStatusRequested(
    GameStatusRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    return emit.forEach(
      _boardInfoRepository.getGameStatus(),
      onData: (status) {
        if (status == GameStatus.resetInProgress) {
          return state.copyWith(
            gameStatus: status,
            boardStatus: BoardStatus.resetInProgress,
          );
        }

        return state.copyWith(gameStatus: status);
      },
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state.copyWith(
          status: CrosswordStatus.failure,
        );
      },
    );
  }

  void _onBoardStatusResumed(
    BoardStatusResumed event,
    Emitter<CrosswordState> emit,
  ) {
    emit(
      state.copyWith(
        boardStatus: BoardStatus.inProgress,
      ),
    );
  }

  void _onMascotDropped(
    MascotDropped event,
    Emitter<CrosswordState> emit,
  ) {
    emit(
      state.copyWith(
        mascotVisible: false,
      ),
    );
  }
}
