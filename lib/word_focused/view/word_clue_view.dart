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
        OutlinedButton.icon(
          onPressed: () {
            context
                .read<WordFocusedBloc>()
                .add(const WordFocusedSolveRequested());
          },
          icon: const Icon(Icons.edit),
          label: Text(l10n.solveIt),
        ),
      ],
    );
  }
}