import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class TopBar extends StatelessWidget {
  const TopBar({required this.wordId, super.key});

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
        IconButton(
          onPressed: () {
            context.read<CrosswordBloc>().add(const WordUnselected());
          },
          icon: const Icon(Icons.cancel),
        ),
      ],
    );
  }
}
