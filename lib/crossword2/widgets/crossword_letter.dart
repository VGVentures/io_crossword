import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

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

        final character = letters[index]?.character ?? word.answer[i];

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
class CrosswordLetter extends StatelessWidget {
  const CrosswordLetter({
    required this.data,
    super.key,
  });

  /// {@macro crossword_letter_data}
  final CrosswordLetterData data;

  void _onTap(BuildContext context) {
    context.read<WordSelectionBloc>().add(LetterSelected(letter: data));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crosswordData = CrosswordLayoutScope.of(context);

    final mascot = data.words.mascot();
    final style = theme.io.crosswordLetterTheme.fromMascot(mascot);

    return GestureDetector(
      onTap: () => _onTap(context),
      child: SizedBox.fromSize(
        size: crosswordData.cellSize,
        child: Padding(
          padding: theme.io.wordInput.secondary.padding,
          child: IoCrosswordLetter(data.character, style: style),
        ),
      ),
    );
  }
}

extension on CrosswordLetterWords {
  /// Returns the mascot of the first team that resolved the letter.
  ///
  /// If `null`, no team has yet resolved the letter.
  Mascots? mascot() {
    return switch (($1?.isSolved ?? false, $2?.isSolved ?? false)) {
      (false, false) => null,
      (true, false) => $1!.mascot,
      (false, true) => $2!.mascot,
      (true, true) =>
        $1!.solvedTimestamp! <= $2!.solvedTimestamp! ? $1!.mascot : $2!.mascot,
    };
  }
}

extension on IoCrosswordLetterTheme {
  IoCrosswordLetterStyle fromMascot(Mascots? mascot) {
    return switch (mascot) // coverage:ignore-line
        {
      Mascots.android => android,
      Mascots.dash => dash,
      Mascots.dino => dino,
      Mascots.sparky => sparky,
      _ => empty,
    };
  }
}
