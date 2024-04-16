import 'package:flutter/material.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSelectionTopBar extends StatelessWidget {
  const WordSelectionTopBar({required this.wordId, super.key});

  final String wordId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          // TODO(any): Open share page
          onPressed: () {}, // coverage:ignore-line
          icon: const Icon(Icons.ios_share),
        ),
        Text(
          wordId,
          style: IoCrosswordTextStyles.labelMD.bold,
        ),
        const CloseWordSelectionIconButton(),
      ],
    );
  }
}
