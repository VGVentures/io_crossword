import 'package:equatable/equatable.dart';

/// {@template word_clue}
/// A model with the word and the clue
/// {@endtemplate}
class WordClue extends Equatable {
  /// {@macro character_data}
  const WordClue({
    required this.word,
    required this.clue,
  });

  /// The [word].
  final String word;

  /// The [clue] for the [word].
  final String clue;

  @override
  List<Object?> get props => [word, clue];
}
