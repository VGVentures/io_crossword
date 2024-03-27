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
    this.renderLimits = const [],
    this.mascot = Mascots.dash,
    this.initials = '',
  });

  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final WordSelection? selectedWord;
  final List<double> renderLimits;
  final Mascots mascot;
  final String initials;

  CrosswordLoaded copyWith({
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    WordSelection? selectedWord,
    List<double>? renderLimits,
    Mascots? mascot,
    String? initials,
  }) {
    return CrosswordLoaded(
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      selectedWord: selectedWord ?? this.selectedWord,
      renderLimits: renderLimits ?? this.renderLimits,
      mascot: mascot ?? this.mascot,
      initials: initials ?? this.initials,
    );
  }

  CrosswordLoaded removeSelectedWord() {
    return CrosswordLoaded(
      sectionSize: sectionSize,
      sections: sections,
      renderLimits: renderLimits,
      mascot: mascot,
      initials: initials,
    );
  }

  @override
  List<Object?> get props => [
        sectionSize,
        sections,
        selectedWord,
        renderLimits,
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
