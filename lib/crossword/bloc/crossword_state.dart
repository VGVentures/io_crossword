part of 'crossword_bloc.dart';

sealed class CrosswordState extends Equatable {
  const CrosswordState();
}

class CrosswordInitial extends CrosswordState {
  const CrosswordInitial();

  @override
  List<Object> get props => [];
}

enum SolvedStatus {
  solved,
  pending,
  invalid,
}

class WordSelection extends Equatable {
  WordSelection({
    required this.section,
    required this.word,
    SolvedStatus? solvedStatus,
  }) : solvedStatus = solvedStatus ??
            (word.solvedTimestamp != null
                ? SolvedStatus.solved
                : SolvedStatus.pending);

  final (int, int) section;
  final Word word;
  final SolvedStatus solvedStatus;

  WordSelection copyWith({SolvedStatus? solvedStatus}) {
    return WordSelection(
      section: section,
      word: word,
      solvedStatus: solvedStatus ?? this.solvedStatus,
    );
  }

  @override
  List<Object> get props => [section, word, solvedStatus];
}

class CrosswordLoaded extends CrosswordState {
  const CrosswordLoaded({
    required this.sectionSize,
    this.sections = const {},
    this.selectedWord,
    this.zoomLimit = 0.35,
    this.mascot = Mascots.dash,
    this.initials = '',
    this.answer = '',
  });

  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final WordSelection? selectedWord;
  final double zoomLimit;
  final Mascots mascot;
  final String initials;
  final String answer;

  CrosswordLoaded copyWith({
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    WordSelection? selectedWord,
    double? zoomLimit,
    Mascots? mascot,
    String? initials,
    String? answer,
  }) {
    return CrosswordLoaded(
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      selectedWord: selectedWord ?? this.selectedWord,
      zoomLimit: zoomLimit ?? this.zoomLimit,
      mascot: mascot ?? this.mascot,
      initials: initials ?? this.initials,
      answer: answer ?? this.answer,
    );
  }

  CrosswordLoaded removeSelectedWord() {
    return CrosswordLoaded(
      sectionSize: sectionSize,
      sections: sections,
      zoomLimit: zoomLimit,
      mascot: mascot,
      initials: initials,
    );
  }

  @override
  List<Object?> get props => [
        sectionSize,
        sections,
        selectedWord,
        zoomLimit,
        mascot,
        initials,
        answer,
      ];
}

class CrosswordError extends CrosswordState {
  const CrosswordError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
