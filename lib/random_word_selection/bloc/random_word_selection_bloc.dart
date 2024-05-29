import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'random_word_selection_event.dart';
part 'random_word_selection_state.dart';

class RandomWordSelectionBloc
    extends Bloc<RandomWordSelectionEvent, RandomWordSelectionState> {
  RandomWordSelectionBloc({
    required CrosswordRepository crosswordRepository,
    required BoardInfoRepository boardInfoRepository,
  })  : _crosswordRepository = crosswordRepository,
        _boardInfoRepository = boardInfoRepository,
        super(const RandomWordSelectionState()) {
    on<RandomWordRequested>(_onRandomWordRequested);
  }

  final CrosswordRepository _crosswordRepository;
  final BoardInfoRepository _boardInfoRepository;

  Future<void> _onRandomWordRequested(
    RandomWordRequested event,
    Emitter<RandomWordSelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RandomWordSelectionStatus.loading));

      final bottomRight = await _boardInfoRepository.getBottomRight();
      final randomSection =
          await _crosswordRepository.getRandomUncompletedSection(bottomRight);

      if (randomSection != null) {
        emit(
          state.copyWith(
            status: event.isInitial
                ? RandomWordSelectionStatus.initialSuccess
                : RandomWordSelectionStatus.success,
            uncompletedSection: randomSection,
          ),
        );
      } else {
        emit(state.copyWith(status: RandomWordSelectionStatus.notFound));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: RandomWordSelectionStatus.failure));
    }
  }
}
