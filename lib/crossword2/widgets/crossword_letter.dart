import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

/// {@template crossword_letter_index}
/// Represents the position of a letter in a crossword chunk.
///
/// The letters are indexed by (row, column) and (0,0) lies at the top-left,
/// hence only positive values are expected.
/// {@endtemplate}
typedef CrosswordLetterIndex = (int, int);

/// {@template crossword_letter_words}
/// Represent the words associated with a letter in a crossword.
///
/// The first letter is the word that goes across, and the second letter is the
/// word that goes down.
///
/// If a letter is not part of a word, the value will be `null`.
///
/// For example, given:
///
/// ```
/// F U N
/// - - O
/// ```
///
/// The letter "N" has the words ("FUN", "NO") associated with it, whereas the
/// letter "F" has the words ("FUN", null) associated with it and the letter "O"
/// has the words (null, "NO") associated with it.
/// {@endtemplate}
typedef CrosswordLetterWords = (Word?, Word?);

/// {@template crossword_letter_data}
/// Defines the data associated with a crossword letter.
/// {@endtemplate}
class CrosswordLetterData extends Equatable {
  /// {@macro crossword_letter_data}
  const CrosswordLetterData({
    required this.index,
    required this.chunkIndex,
    required this.character,
    required this.words,
  });

  /// Maps all the words in a chunk to their letters.
  static Map<CrosswordLetterIndex, CrosswordLetterData> fromChunk(
    BoardSection chunk,
  ) {
    final letters = <CrosswordLetterIndex, CrosswordLetterData>{};
    final chunkIndex = (chunk.position.x, chunk.position.y);

    for (final word in chunk.words) {
      for (var i = 0; i < word.length; i++) {
        final index = word.axis == Axis.horizontal
            ? (word.position.x + i, word.position.y)
            : (word.position.x, word.position.y + i);

        final character = letters[index]?.character ?? word.answer?[i];

        var words = letters[index]?.words ?? (null, null);
        words =
            word.axis == Axis.horizontal ? (word, words.$2) : (words.$1, word);

        letters[index] = CrosswordLetterData(
          chunkIndex: chunkIndex,
          character: character,
          index: index,
          words: words,
        );
      }
    }

    return letters;
  }

  /// {@macro crossword_letter_index}
  final CrosswordLetterIndex index;

  /// {@macro crossword_chunk_index}
  final CrosswordChunkIndex chunkIndex;

  /// The character of the letter.
  ///
  /// `null` if it is yet to be resolved.
  final String? character;

  /// {@macro crossword_letter_words}
  ///
  /// At least one of the words should be non-null.
  final CrosswordLetterWords words;

  @override
  List<Object?> get props => [index, chunkIndex, character, words];
}

/// {@template crossword_letter}
/// A letter in a crossword puzzle.
///
/// If the letter is yet to be known (not yet resolved), it will display an
/// empty cell. Whereas if the letter is known, it will display the character
/// themed by the first team that resolved it.
/// {@endtemplate}
// TODO(alestiago): Style the letter based on the team that resolved it:
// https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6472452796
class CrosswordLetter extends StatelessWidget {
  const CrosswordLetter({
    required this.data,
    super.key,
  });

  /// {@macro crossword_letter_data}
  final CrosswordLetterData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crosswordData = CrosswordLayoutScope.of(context);

    final child = data.character != null
        ? Center(
            child: Text(
              data.character!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black),
            ),
          )
        : null;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white,
      ),
      child: SizedBox.fromSize(
        size: crosswordData.cellSize,
        child: child,
      ),
    );
  }
}