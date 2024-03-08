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

class CrosswordLoaded extends CrosswordState {
  const CrosswordLoaded({
    required this.sectionSize,
    required this.sections,
    this.width = 40,
    this.height = 40,
    this.selectedWord,
  });

  final int width;
  final int height;
  final int sectionSize;
  final Map<(int, int), BoardSection> sections;
  final WordSelection? selectedWord;

  CrosswordLoaded copyWith({
    int? width,
    int? height,
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    WordSelection? selectedWord,
  }) {
    return CrosswordLoaded(
      width: width ?? this.width,
      height: height ?? this.height,
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
      selectedWord: selectedWord ?? this.selectedWord,
    );
  }

  @override
  List<Object?> get props => [
        width,
        height,
        sectionSize,
        sections,
        selectedWord,
      ];
}

class CrosswordError extends CrosswordState {
  const CrosswordError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
