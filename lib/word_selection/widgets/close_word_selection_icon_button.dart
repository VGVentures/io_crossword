import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/streak/streak.dart';
import 'package:io_crossword/word_selection/word_selection.dart'
    hide WordUnselected;
import 'package:io_crossword/word_selection/word_selection.dart' as selection;
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template close_word_selection_icon_button}
/// A button that closes the word selection.
/// {@endtemplate}
// TODO(any): If the player was solving, closing should display a
// dialog to confirm the action:
// https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6442813420
class CloseWordSelectionIconButton extends StatelessWidget {
  /// {@macro close_word_selection_icon_button}
  const CloseWordSelectionIconButton({super.key});

  void _onClose(BuildContext context) {
    final status = context.read<WordSelectionBloc>().state.status;

    switch (status) {
      case WordSelectionStatus.validating:
      case WordSelectionStatus.incorrect:
      case WordSelectionStatus.failure:
      case WordSelectionStatus.solving:
        StreakAtRiskView.showModal(context);
      case WordSelectionStatus.empty:
      case WordSelectionStatus.preSolving:
      case WordSelectionStatus.solved:
        context.read<CrosswordBloc>().add(const WordUnselected());
        context.read<WordSelectionBloc>().add(const selection.WordUnselected());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return IconButton(
      onPressed: () => _onClose(context),
      icon: const Icon(Icons.cancel),
      style: themeData.io.iconButtonTheme.filled,
    );
  }
}
