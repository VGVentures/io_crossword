import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc({
    required CrosswordRepository crosswordRepository,
    required BoardInfoRepository boardInfoRepository,
  })  : _crosswordRepository = crosswordRepository,
        _boardInfoRepository = boardInfoRepository,
        super(const CrosswordState()) {
    on<BoardLoadingInformationRequested>(_onBoardLoadingInformationRequested);
    on<BoardStatusPaused>(_onBoardStatusPaused);
    on<BoardStatusResumed>(_onBoardStatusResumed);
    on<MascotDropped>(_onMascotDropped);
    on<CrosswordSectionsLoaded>(_onCrosswordSectionsLoaded);
  }

  final CrosswordRepository _crosswordRepository;
  final BoardInfoRepository _boardInfoRepository;

  FutureOr<void> _onBoardLoadingInformationRequested(
    BoardLoadingInformationRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    emit(state.copyWith(mascotVisible: true));

    try {
      final zoomLimit = await _boardInfoRepository.getZoomLimit();
      final sectionSize = await _boardInfoRepository.getSectionSize();
      final bottomRight = await _boardInfoRepository.getBottomRight();

      emit(
        state.copyWith(
          status: CrosswordStatus.success,
          zoomLimit: zoomLimit,
          sectionSize: sectionSize,
          bottomRight: (bottomRight.x, bottomRight.y),
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

  void _onBoardStatusPaused(
    BoardStatusPaused event,
    Emitter<CrosswordState> emit,
  ) {
    emit(
      state.copyWith(
        boardStatus: BoardStatus.resetInProgress,
      ),
    );
  }

  void _onBoardStatusResumed(
    BoardStatusResumed event,
    Emitter<CrosswordState> emit,
  ) {
    emit(
      state.copyWith(
        status: CrosswordStatus.initial,
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

  Future<void> _onCrosswordSectionsLoaded(
    CrosswordSectionsLoaded event,
    Emitter<CrosswordState> emit,
  ) async {
    return emit.forEach(
      _crosswordRepository.loadBoardSections(),
      onData: (sections) {
        final keySections = <(int, int), BoardSection>{};

        for (final section in sections) {
          final index = (section.position.x, section.position.y);

          keySections[index] = section;
        }

        return state.copyWith(
          status: CrosswordStatus.ready,
          sections: keySections,
          sectionSize: keySections.entries.first.value.size,
          initialWord: event.selectedWord,
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
}
