import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc() : super(const CrosswordInitial()) {
    on<InitialBoardLoadRequested>(_onInitialBoardLoadRequested);
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
  }

  // TODO(any): Replace with real data
  static int _id = 0;

  Future<void> _onInitialBoardLoadRequested(
    InitialBoardLoadRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    final section = BoardSection(
      id: '${_id++}',
      position: const Point(2, 2),
      size: 40,
      words: [
        Word(
          axis: Axis.horizontal,
          position: const Point(0, 0),
          answer: 'flutter',
          clue: 'flutter',
          hints: const ['dart', 'mobile', 'cross-platform'],
          visible: true,
          solvedTimestamp: null,
        ),
      ],
      borderWords: const [],
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
        id: '${_id++}',
        position: Point(event.position.$1, event.position.$2),
        size: 40,
        words: [
          Word(
            axis: Axis.horizontal,
            position: const Point(0, 0),
            answer: 'flutter',
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
