import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSelectionTopBar extends StatelessWidget {
  const WordSelectionTopBar({super.key});

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
        BlocSelector<WordSelectionBloc, WordSelectionState, String>(
          selector: (state) => state.word?.word.id ?? '',
          builder: (context, wordIdentifier) {
            return Text(
              wordIdentifier,
              style: IoCrosswordTextStyles.labelMD.bold,
            );
          },
        ),
        const CloseWordSelectionIconButton(),
      ],
    );
  }
}
