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
    this.sectionSize = 0,
    this.sections = const {},
    this.selectedWord,
    this.zoomLimit = 0.35,
  });

  final CrosswordStatus status;
  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final WordSelection? selectedWord;
  final double zoomLimit;

  CrosswordState copyWith({
    CrosswordStatus? status,
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    WordSelection? selectedWord,
    double? zoomLimit,
  }) {
    return CrosswordState(
      status: status ?? this.status,
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      selectedWord: selectedWord ?? this.selectedWord,
      zoomLimit: zoomLimit ?? this.zoomLimit,
    );
  }

  CrosswordState removeSelectedWord() {
    return CrosswordState(
      status: status,
      sectionSize: sectionSize,
      sections: sections,
      zoomLimit: zoomLimit,
    );
  }

  @override
  List<Object?> get props =>
      [status, sectionSize, sections, selectedWord, zoomLimit];
}
