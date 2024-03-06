import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc(this.crosswordRepository) : super(const CrosswordInitial()) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
  }

  final CrosswordRepository crosswordRepository;

  Future<void> _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    return emit.forEach(
      crosswordRepository.watchSectionFromPosition(
        Point(event.position.$1, event.position.$2),
      ),
      onData: (section) {
        if (section == null) return state;
        final newSection = {
          (section.position.x, section.position.y): section,
        };

        return CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 300,
          sections: state is CrosswordLoaded
              ? {
                  ...(state as CrosswordLoaded).sections,
                  ...newSection,
                }
              : {...newSection},
        );
      },
    );
  }

  FutureOr<void> _onWordSelected(
    WordSelected event,
    Emitter<CrosswordState> emit,
  ) {
    final currentState = state;
    if (currentState is CrosswordLoaded) {
      emit(
        currentState.withSelectedWord(
          WordSelection(
            section: event.section,
            wordId: event.wordId,
          ),
        ),
      );
    }
  }
}
