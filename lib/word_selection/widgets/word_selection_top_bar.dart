import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:intl/intl.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSelectionTopBar extends StatelessWidget {
  const WordSelectionTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          // TODO(any): Open share page
          onPressed: () {}, // coverage:ignore-line
          icon: const Icon(Icons.ios_share),
          style: themeData.io.iconButtonTheme.filled,
        ),
        BlocSelector<WordSelectionBloc, WordSelectionState, Word?>(
          selector: (state) => state.word?.word,
          builder: (context, word) {
            if (word == null) return const SizedBox.shrink();
            return Text(
              wordIdentifier(word),
              style: themeData.textTheme.labelLarge,
            );
          },
        ),
        const CloseWordSelectionIconButton(),
      ],
    );
  }

  String wordIdentifier(Word word) {
    final direction = word.axis == Axis.horizontal ? 'Across' : 'Down';
    final formatter = NumberFormat('#,###');
    final id = int.tryParse(word.id);
    if (id == null) return '';
    return '${formatter.format(id)} $direction'.toUpperCase();
  }
}
