import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionStatus =
        context.select((WordSelectionBloc bloc) => bloc.state.status);

    return selectionStatus != WordSelectionStatus.empty
        ? const SizedBox.shrink()
        : const BottomBarContent();
  }
}

@visibleForTesting
class BottomBarContent extends StatelessWidget {
  @visibleForTesting
  const BottomBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        color: IoCrosswordColors.darkGray,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {
                EndGameCheck.openDialog(context);
              },
              child: Text(
                l10n.endGame,
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {}, // coverage:ignore-line
              icon: const Icon(Icons.location_searching),
              label: Text(l10n.findNewWord),
            ),
          ],
        ),
      ),
    );
  }
}
