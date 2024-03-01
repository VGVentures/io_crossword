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
    required this.sections,
  });

  final int width;
  final int height;
  final List<BoardSection> sections;

  @override
  List<Object> get props => [width, height, sections];
}

class CrosswordError extends CrosswordState {
  const CrosswordError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
