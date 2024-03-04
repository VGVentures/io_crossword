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
        final section1 = BoardSection(
          id: '',
          position: Point(2, 2),
          size: 300,
          words: [
            Word(
              axis: Axis.horizontal,
              position: const Point(1, 0),
              answer: 'flutterazertyuiopazertyuiop',
              clue: 'flutter',
              hints: const ['dart', 'mobile', 'cross-platform'],
              visible: true,
              solvedTimestamp: null,
            ),
            Word(
              axis: Axis.vertical,
              position: const Point(4, 1),
              answer: 'android',
              clue: 'flutter',
              hints: const ['dart', 'mobile', 'cross-platform'],
              visible: false,
              solvedTimestamp: null,
            ),
            Word(
              axis: Axis.vertical,
              position: const Point(8, 3),
              answer: 'dino',
              clue: 'flutter',
              hints: const ['dart', 'mobile', 'cross-platform'],
              visible: true,
              solvedTimestamp: null,
            ),
            Word(
              position: const Point(4, 6),
              axis: Axis.horizontal,
              answer: 'sparky',
              clue: 'flutter',
              hints: const ['dart', 'mobile', 'cross-platform'],
              visible: true,
              solvedTimestamp: null,
            ),
          ],
          borderWords: const [],
        );
        final allSections = <BoardSection>[];
        for (final section in sections) {
          final x = section.position.x - 21;
          final y = section.position.y + 80;
          final moduloX = x / 300;
          final moduloY = y / 300;
          print('$moduloX, $moduloY');
          final updated = section.copyWith(
              position: Point(moduloX.round(), moduloY.round()));
          allSections.add(updated);
        }
        return CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 300,
          sections: {
            /*   (sections.first.position.x, sections.first.position.y):
                sections.first,*/
          },
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
      if (loadedState.sections.length >= 1) return;
      try {
        final nextKey = loadedState.allSections.keys.firstWhere(
          (element) =>
              !loadedState.sections.containsKey(element) &&
              element.$1 == 0 &&
              element.$2 == 0,
        );
        final section = loadedState.allSections[nextKey];

        if (section != null) {
          print('added $nextKey');
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
