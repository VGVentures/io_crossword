import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc() : super(const CrosswordInitial()) {
    on<InitialBoardLoadRequested>(_onInitialBoardLoadRequested);
    on<BoardSectionRequested>(_onBoardSectionRequested);
  }

  Future<void> _onInitialBoardLoadRequested(
    InitialBoardLoadRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    const section = BoardSection(
      id: '1',
      position: Point(2, 2),
      width: 40,
      height: 40,
      words: [
        Word(
          id: '1',
          axis: Axis.horizontal,
          position: Point(0, 0),
          answer: 'flutter',
          clue: 'flutter',
          hints: ['dart', 'mobile', 'cross-platform'],
          visible: true,
          solvedTimestamp: null,
        ),
      ],
    );

    emit(
      CrosswordLoaded(
        width: 40,
        height: 40,
        sectionSize: 400,
        sections: {
          (section.position.x, section.position.y): section,
        },
      ),
    );
  }

  Future<void> _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    final loadedState = state;
    if (loadedState is CrosswordLoaded) {
      final section = BoardSection(
        id: '',
        position: Point(event.position.$1, event.position.$2),
        width: 40,
        height: 40,
        words: const [
          Word(
            id: '',
            position: Point(0, 0),
            answer: 'flutter',
            clue: 'flutter',
            hints: ['dart', 'mobile', 'cross-platform'],
            visible: true,
            solvedTimestamp: null,
          ),
          Word(
            id: '',
            position: Point(4, 1),
            answer: 'android',
            clue: 'flutter',
            hints: ['dart', 'mobile', 'cross-platform'],
            visible: true,
            solvedTimestamp: null,
          ),
          Word(
            id: '',
            position: Point(8, 3),
            answer: 'dino',
            clue: 'flutter',
            hints: ['dart', 'mobile', 'cross-platform'],
            visible: true,
            solvedTimestamp: null,
          ),
          Word(
            id: '',
            position: Point(4, 6),
            answer: 'sparky',
            clue: 'flutter',
            hints: ['dart', 'mobile', 'cross-platform'],
            visible: true,
            solvedTimestamp: null,
          ),
        ],
      );

      emit(
        loadedState.copyWith(
          sections: {
            ...loadedState.sections,
            (section.position.x, section.position.y): section,
          },
        ),
      );
    }
  }
}
