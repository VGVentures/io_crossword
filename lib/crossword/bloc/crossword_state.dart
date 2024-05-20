part of 'crossword_bloc.dart';

enum CrosswordStatus {
  initial,
  failure,
  success,
  ready,
}

enum BoardStatus {
  inProgress,
  resetInProgress,
}

class CrosswordState extends Equatable {
  const CrosswordState({
    this.status = CrosswordStatus.initial,
    this.boardStatus = BoardStatus.inProgress,
    this.sectionSize = 0,
    this.sections = const {},
    this.zoomLimit = 0.35,
    this.mascotVisible = true,
    this.bottomRight = (0, 0),
    this.initialWord,
  });

  final CrosswordStatus status;
  final BoardStatus boardStatus;
  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final double zoomLimit;
  final bool mascotVisible;
  final CrosswordChunkIndex bottomRight;
  final SelectedWord? initialWord;

  CrosswordState copyWith({
    CrosswordStatus? status,
    BoardStatus? boardStatus,
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    double? zoomLimit,
    bool? mascotVisible,
    CrosswordConfiguration? configuration,
    CrosswordChunkIndex? bottomRight,
    SelectedWord? initialWord,
  }) {
    return CrosswordState(
      status: status ?? this.status,
      boardStatus: boardStatus ?? this.boardStatus,
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      zoomLimit: zoomLimit ?? this.zoomLimit,
      mascotVisible: mascotVisible ?? this.mascotVisible,
      bottomRight: bottomRight ?? this.bottomRight,
      initialWord: initialWord ?? this.initialWord,
    );
  }

  @override
  List<Object?> get props => [
        status,
        boardStatus,
        sectionSize,
        sections,
        zoomLimit,
        mascotVisible,
        bottomRight,
        initialWord,
      ];
}
