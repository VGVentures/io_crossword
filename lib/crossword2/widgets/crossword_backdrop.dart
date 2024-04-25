import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template crossword_backdrop}
/// A black pane that covers the crossword.
///
/// Usually used to dim the crossword when a word is selected. Tapping on the
/// pane will attempt to unselect the selected word.
/// {@endtemplate}
class CrosswordBackdrop extends StatelessWidget {
  /// {@macro crossword_backdrop}
  const CrosswordBackdrop({super.key});

  void _onTap(BuildContext context) {
    context.read<WordSelectionBloc>().add(const WordUnselected());
  }

  @override
  Widget build(BuildContext context) {
    final crosswordLayout = CrosswordLayoutScope.of(context);

    return GestureDetector(
      onTap: () => _onTap(context),
      child: SizedBox.fromSize(
        size:
            crosswordLayout.padding.inflateSize(crosswordLayout.crosswordSize),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: IoCrosswordColors.black.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
