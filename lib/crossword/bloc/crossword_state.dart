part of 'crossword_bloc.dart';

enum CrosswordStatus {
  initial,
  success,
  failure,
}

enum WordStatus {
  solved,
  pending,
  invalid,
}

enum BoardStatus {
  inProgress,
  resetInProgress,
}

class WordSelection extends Equatable {
  WordSelection({
    required this.section,
    required this.word,
    WordStatus? solvedStatus,
  }) : solvedStatus = solvedStatus ??
            (word.solvedTimestamp != null
                ? WordStatus.solved
                : WordStatus.pending);

  final (int, int) section;
  final Word word;
  final WordStatus solvedStatus;

  WordSelection copyWith({WordStatus? solvedStatus}) {
    return WordSelection(
      section: section,
      word: word,
      solvedStatus: solvedStatus ?? this.solvedStatus,
    );
  }

  @override
  List<Object> get props => [section, word, solvedStatus];
}

class CrosswordState extends Equatable {
  const CrosswordState({
    this.status = CrosswordStatus.initial,
    this.gameStatus = GameStatus.inProgress,
    this.boardStatus = BoardStatus.inProgress,
    this.sectionSize = 0,
    this.sections = const {},
    this.selectedWord,
    this.zoomLimit = 0.35,
    this.mascotVisible = true,
  });

  final CrosswordStatus status;
  final GameStatus gameStatus;
  final BoardStatus boardStatus;
  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final WordSelection? selectedWord;
  final double zoomLimit;
  final bool mascotVisible;

  CrosswordState copyWith({
    CrosswordStatus? status,
    GameStatus? gameStatus,
    BoardStatus? boardStatus,
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    WordSelection? selectedWord,
    double? zoomLimit,
    bool? mascotVisible,
  }) {
    return CrosswordState(
      status: status ?? this.status,
      gameStatus: gameStatus ?? this.gameStatus,
      boardStatus: boardStatus ?? this.boardStatus,
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      selectedWord: selectedWord ?? this.selectedWord,
      zoomLimit: zoomLimit ?? this.zoomLimit,
      mascotVisible: mascotVisible ?? this.mascotVisible,
    );
  }

  CrosswordState removeSelectedWord() {
    return CrosswordState(
      status: status,
      sectionSize: sectionSize,
      sections: sections,
      zoomLimit: zoomLimit,
      mascotVisible: mascotVisible,
    );
  }

  @override
  List<Object?> get props => [
        status,
        gameStatus,
        boardStatus,
        sectionSize,
        sections,
        selectedWord,
        zoomLimit,
        mascotVisible,
      ];
}
