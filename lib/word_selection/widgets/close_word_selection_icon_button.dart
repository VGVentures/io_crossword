import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/streak/streak.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template close_word_selection_icon_button}
/// A button that closes the word selection.
/// {@endtemplate}
class CloseWordSelectionIconButton extends StatelessWidget {
  /// {@macro close_word_selection_icon_button}
  const CloseWordSelectionIconButton({super.key});

  void _onClose(BuildContext context) {
    StreakAtRiskView.check(
      context,
      onLeave: () {
        context.read<WordSelectionBloc>().add(const WordUnselected());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return IconButton(
      onPressed: () => _onClose(context),
      icon: const Icon(Icons.close),
      style: themeData.io.iconButtonTheme.filled,
    );
  }
}
