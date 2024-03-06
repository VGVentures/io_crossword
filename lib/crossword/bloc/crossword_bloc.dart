import 'package:bloc/bloc.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc(this.crosswordRepository)
      : super(
          const CrosswordLoaded(
            width: 40,
            height: 40,
            sectionSize: 300,
            sections: {},
          ),
        ) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
  }

  final CrosswordRepository crosswordRepository;

  Future<void> _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    final loadedState = state;
    if (loadedState is CrosswordLoaded) {
      return emit.forEach(
        crosswordRepository.watchSectionFromPosition(
          Point(event.position.$1, event.position.$2),
        ),
        onData: (section) {
          if (section == null) return state;
          return CrosswordLoaded(
            width: 40,
            height: 40,
            sectionSize: 300,
            sections: {
              ...loadedState.sections,
              (section.position.x, section.position.y): section,
            },
          );
        },
      );
    }
  }
}
