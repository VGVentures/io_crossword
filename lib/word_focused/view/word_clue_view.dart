import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordClueDesktopView extends StatelessWidget {
  const WordClueDesktopView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final solved = selectedWord.solvedStatus == WordStatus.solved;

    return Column(
      children: [
        TopBar(wordId: selectedWord.word.id),
        const SizedBox(height: 8),
        const Spacer(),
        Text(
          selectedWord.word.clue,
          style: IoCrosswordTextStyles.titleMD,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        const SizedBox(height: 8),
        if (!solved)
          OutlinedButton.icon(
            onPressed: () {
              context.read<WordSelectionBloc>().add(const WordSolveRequested());
            },
            icon: const Icon(Icons.edit),
            label: Text(l10n.solveIt),
          ),
      ],
    );
  }
}

class WordClueMobileView extends StatelessWidget {
  const WordClueMobileView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final solved = selectedWord.solvedStatus == WordStatus.solved;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TopBar(wordId: selectedWord.word.id),
        const SizedBox(height: 24),
        Text(
          selectedWord.word.clue,
          style: IoCrosswordTextStyles.titleMD,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (!solved)
          OutlinedButton.icon(
            onPressed: () {
              context.read<WordSelectionBloc>().add(const WordSolveRequested());
            },
            icon: const Icon(Icons.edit),
            label: Text(l10n.solveIt),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
