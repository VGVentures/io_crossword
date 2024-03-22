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
    required this.wordId,
  });

  final (int, int) section;
  final String wordId;

  @override
  List<Object> get props => [section, wordId];
}

enum RenderMode { game, snapshot }

class CrosswordLoaded extends CrosswordState {
  const CrosswordLoaded({
    required this.sectionSize,
    this.sections = const {},
    this.selectedWord,
    this.renderMode = RenderMode.game,
    this.renderLimits = const [],
    this.mascot = Mascots.dash,
    this.initials = '',
  });

  final int sectionSize;
  final RenderMode renderMode;
  final List<double> renderLimits;
  final Map<(int, int), BoardSection> sections;
  final WordSelection? selectedWord;
  final Mascots mascot;
  final String initials;

  CrosswordLoaded copyWith({
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    WordSelection? selectedWord,
    List<double>? renderLimits,
    RenderMode? renderMode,
    Mascots? mascot,
    String? initials,
  }) {
    return CrosswordLoaded(
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      selectedWord: selectedWord ?? this.selectedWord,
      renderMode: renderMode ?? this.renderMode,
      mascot: mascot ?? this.mascot,
      renderLimits: renderLimits ?? this.renderLimits,
      initials: initials ?? this.initials,
    );
  }

  @override
  List<Object?> get props => [
        sectionSize,
        sections,
        selectedWord,
        renderMode,
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
