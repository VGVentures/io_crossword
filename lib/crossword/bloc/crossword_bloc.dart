import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc() : super(const CrosswordInitial()) {
    on<InitialBoardLoadRequested>(_onInitialBoardLoadRequested);
  }

  Future<void> _onInitialBoardLoadRequested(
    InitialBoardLoadRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    const section = BoardSection(
      id: '1',
      position: Point(0, 0),
      width: 40,
      height: 40,
      words: [
        Word(
          id: '1',
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
      const CrosswordLoaded(
        width: 40,
        height: 40,
        sections: [section],
      ),
    );
  }
}
