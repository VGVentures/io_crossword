part of 'crossword_bloc.dart';

sealed class CrosswordState extends Equatable {
  const CrosswordState();
}

class CrosswordInitial extends CrosswordState {
  const CrosswordInitial();
  @override
  List<Object> get props => [];
}

class CrosswordLoading extends CrosswordState {
  const CrosswordLoading();
  @override
  List<Object> get props => [];
}

class CrosswordLoaded extends CrosswordState {
  const CrosswordLoaded({
    required this.width,
    required this.height,
    required this.sectionSize,
    required this.sections,
  });

  final int width;
  final int height;
  final int sectionSize;
  final Map<(int, int), BoardSection> sections;

  CrosswordLoaded copyWith({
    int? width,
    int? height,
    int? sectionSize,
    Map<(int, int), BoardSection>? sections,
    Map<(int, int), BoardSection>? allSections,
  }) {
    return CrosswordLoaded(
      width: width ?? this.width,
      height: height ?? this.height,
      sectionSize: sectionSize ?? this.sectionSize,
      sections: sections ?? this.sections,
    );
  }

  @override
  List<Object> get props => [width, height, sectionSize, sections];
}

class CrosswordError extends CrosswordState {
  const CrosswordError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
