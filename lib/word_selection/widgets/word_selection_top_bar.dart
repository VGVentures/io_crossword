import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:intl/intl.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/share/share.dart';
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
          onPressed: () {
            ShareWordPage.showModal(context);
          },
          icon: const Icon(Icons.ios_share),
          style: themeData.io.iconButtonTheme.filled,
        ),
        BlocSelector<WordSelectionBloc, WordSelectionState, SelectedWord?>(
          selector: (state) => state.word,
          builder: (context, word) {
            if (word?.word == null) return const SizedBox.shrink();

            final solvedByOther = context.select<CrosswordBloc, bool>(
              (bloc) {
                final currentWord = bloc.state.sections[word!.section]!.words
                    .firstWhere((element) => element.id == word.word.id);
                return currentWord.solvedTimestamp != null;
              },
            );

            return Text(
              solvedByOther ? 'SOLVED BY OTHER' : wordIdentifier(word!.word),
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
