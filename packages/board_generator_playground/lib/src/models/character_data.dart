import 'package:board_generator_playground/board_generator_playground.dart';
import 'package:equatable/equatable.dart';

/// {@template character_data}
/// The data for a character on the board.
/// {@endtemplate}
class CharacterData extends Equatable {
  /// {@macro character_data}
  const CharacterData({
    required this.character,
    required this.wordEntry,
  });

  /// The character.
  final String character;

  /// The words that contain this character.
  final Set<WordEntry> wordEntry;

  @override
  List<Object?> get props => [character, wordEntry];
}
