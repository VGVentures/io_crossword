import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
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
    context.read<CrosswordBloc>().add(const WordUnselected());
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
