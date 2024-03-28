part of 'crossword_bloc.dart';

sealed class CrosswordState extends Equatable {
  const CrosswordState();
}

class CrosswordInitial extends CrosswordState {
  const CrosswordInitial();

  @override
  List<Object> get props => [];
}

class WordSelection extends Equatable {
  const WordSelection({
    required this.section,
    required this.word,
  });

  final (int, int) section;
  final Word word;

  @override
  List<Object> get props => [section, word];
}

class CrosswordLoaded extends CrosswordState {
  const CrosswordLoaded({
    required this.sectionSize,
    this.sections = const {},
    this.selectedWord,
    this.zoomLimit = 0.4,
    this.mascot = Mascots.dash,
    this.initials = '',
  });

  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final WordSelection? selectedWord;
  final double zoomLimit;
  final Mascots mascot;
  final String initials;

  CrosswordLoaded copyWith({
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    WordSelection? selectedWord,
    double? zoomLimit,
    Mascots? mascot,
    String? initials,
  }) {
    return CrosswordLoaded(
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      selectedWord: selectedWord ?? this.selectedWord,
      zoomLimit: zoomLimit ?? this.zoomLimit,
      mascot: mascot ?? this.mascot,
      initials: initials ?? this.initials,
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
      ];
}

class CrosswordError extends CrosswordState {
  const CrosswordError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
