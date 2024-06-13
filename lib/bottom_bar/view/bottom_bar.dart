import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionStatus =
        context.select((WordSelectionBloc bloc) => bloc.state.status);

    final mascotVisible =
        context.select((CrosswordBloc bloc) => bloc.state.mascotVisible);

    final boardStatus = context.select(
      (CrosswordBloc bloc) => bloc.state.boardStatus,
    );

    return selectionStatus != WordSelectionStatus.empty ||
            mascotVisible ||
            boardStatus == BoardStatus.resetInProgress
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
        height: 104,
        padding: const EdgeInsets.symmetric(vertical: 24),
        color: IoCrosswordColors.darkGray,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () {
                context
                    .read<AudioController>()
                    .playSfx(Assets.music.startButton1);
                EndGameCheck.openDialog(context);
              },
              child: Text(l10n.endGame),
            ),
            const SizedBox(width: 16),
            const FindWordButton(),
          ],
        ),
      ),
    );
  }
}

class FindWordButton extends StatelessWidget {
  const FindWordButton({super.key});

  void _onPressed(BuildContext context) {
    context.read<AudioController>().playSfx(Assets.music.startButton1);
    context.read<RandomWordSelectionBloc>().add(const RandomWordRequested());
  }

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);
    final l10n = context.l10n;

    switch (layout) {
      case IoLayoutData.large:
        return OutlinedButton.icon(
          onPressed: () => _onPressed(context),
          icon: const Icon(Icons.location_searching),
          label: Text(l10n.findNewWord),
        );
      case IoLayoutData.small:
        return OutlinedButton.icon(
          onPressed: () => _onPressed(context),
          label: Text(l10n.findWord),
        );
    }
  }
}
