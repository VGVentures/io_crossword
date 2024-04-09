import 'package:flutter/material.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

class WordSuccessDesktopView extends StatelessWidget {
  const WordSuccessDesktopView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        TopBar(wordId: selectedWord.word.id),
        const Spacer(),
        Text(l10n.wordSolved),
        const Spacer(),
      ],
    );
  }
}

class WordSuccessMobileView extends StatelessWidget {
  const WordSuccessMobileView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        TopBar(wordId: selectedWord.word.id),
        const SizedBox(height: 40),
        Text(l10n.wordSolved),
        const SizedBox(height: 40),
      ],
    );
  }
}
