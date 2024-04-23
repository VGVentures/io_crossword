import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordBackdrop extends StatelessWidget {
  const CrosswordBackdrop({super.key});

  void _onTap(BuildContext context) {
    context.read<WordSelectionBloc>().add(const WordUnselected());
  }

  @override
  Widget build(BuildContext context) {
    final quad = QuadScope.of(context);

    return GestureDetector(
      onTap: () => _onTap(context),
      child: SizedBox.fromSize(
        size: quad.toSize(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: IoCrosswordColors.black.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

extension on Quad {
  Size toSize() {
    return Size(
      point2.x - point0.x,
      point2.y - point0.y,
    );
  }
}
