import 'package:bloc/bloc.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc(this.crosswordRepository) : super(const CrosswordInitial()) {
    on<InitialBoardLoadRequested>(_onInitialBoardLoadRequested);
    on<BoardSectionRequested>(_onBoardSectionRequested);
  }

  final CrosswordRepository crosswordRepository;

  Future<void> _onInitialBoardLoadRequested(
    InitialBoardLoadRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    return emit.forEach(
      crosswordRepository.watchSections(),
      onData: (sections) {
        final allSections = <BoardSection>[];
        // To be removed...
        // Translate letters coordinates to sections coordinates
        for (final section in sections) {
          final x = section.position.x - 21;
          final y = section.position.y + 80;
          final moduloX = x / 300;
          final moduloY = y / 300;
          final updated = section.copyWith(
              position: Point(moduloX.round(), moduloY.round()));
          allSections.add(updated);
        }
        return CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 300,
          sections: const {},
          allSections: {
            for (final section in allSections)
              (section.position.x, section.position.y): section,
          },
        );
      },
    );
  }

  Future<void> _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    final loadedState = state;
    if (loadedState is CrosswordLoaded) {
      if (loadedState.sections.length >= 20) return;
      try {
        final nextKey = loadedState.allSections.keys.firstWhere(
            (element) => !loadedState.sections.containsKey(
                element) /*&&
              element.$1 == 0 &&
              element.$2 == 0,*/
            );
        final section = loadedState.allSections[nextKey];

        if (section != null) {
          emit(
            loadedState.copyWith(
              sections: {
                ...loadedState.sections,
                (section.position.x, section.position.y): section,
              },
            ),
          );
        }
      } catch (e) {
        //print('noproblem');
      }
    }
  }
}
