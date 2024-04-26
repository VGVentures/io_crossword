import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'random_word_selection_event.dart';
part 'random_word_selection_state.dart';

class RandomWordSelectionBloc
    extends Bloc<RandomWordSelectionEvent, RandomWordSelectionState> {
  RandomWordSelectionBloc({
    required CrosswordRepository crosswordRepository,
  })  : _crosswordRepository = crosswordRepository,
        super(const RandomWordSelectionState()) {
    on<RandomWordRequested>(_onRandomWordRequested);
  }

  final CrosswordRepository _crosswordRepository;

  Future<void> _onRandomWordRequested(
    RandomWordRequested event,
    Emitter<RandomWordSelectionState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RandomWordSelectionStatus.loading));
      //await Future.delayed(const Duration(seconds: 1));

      final randomSection =
          await _crosswordRepository.getRandomUncompletedSection();
      if (randomSection != null) {
        emit(
          state.copyWith(
            status: RandomWordSelectionStatus.success,
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
