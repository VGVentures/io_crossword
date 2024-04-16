import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSelectionView extends StatelessWidget {
  const WordSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord =
        context.select((CrosswordBloc bloc) => bloc.state.selectedWord);
    if (selectedWord == null) {
      return const SizedBox.shrink();
    }

    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.large => WordSelectionLargeView(selectedWord),
      IoLayoutData.small => WordSelectionSmallView(selectedWord),
    };
  }
}

class WordSelectionLargeView extends StatelessWidget {
  @visibleForTesting
  const WordSelectionLargeView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  static const widthRatio = 0.35;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: double.infinity,
        width: size.width * widthRatio,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        color: IoCrosswordColors.darkGray,
        child: BlocBuilder<WordSelectionBloc, WordSelectionState>(
          builder: (context, state) {
            // coverage:ignore-start
            final view = switch (state.status) {
              WordSelectionStatus.preSolving =>
                WordPreSolvingLargeView(selectedWord),
              WordSelectionStatus.validating ||
              WordSelectionStatus.incorrect ||
              WordSelectionStatus.failure ||
              WordSelectionStatus.solving =>
                WordSolvingView(selectedWord: selectedWord),
              WordSelectionStatus.solved =>
                WordSuccessView(selectedWord: selectedWord),
            };
            // coverage:ignore-end
            return view;
          },
        ),
      ),
    );
  }
}

@visibleForTesting
class WordSelectionSmallView extends StatelessWidget {
  @visibleForTesting
  const WordSelectionSmallView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: IoCrosswordColors.darkGray,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: BlocSelector<WordSelectionBloc, WordSelectionState,
              WordSelectionStatus>(
            selector: (state) => state.status,
            builder: (context, status) {
              // coverage:ignore-start
              final view = switch (status) {
                WordSelectionStatus.preSolving =>
                  WordPreSolvingSmallView(selectedWord),
                WordSelectionStatus.validating ||
                WordSelectionStatus.incorrect ||
                WordSelectionStatus.failure ||
                WordSelectionStatus.solving =>
                  WordSolvingView(selectedWord: selectedWord),
                WordSelectionStatus.solved =>
                  WordSuccessView(selectedWord: selectedWord),
              };
              // coverage:ignore-end
              return view;
            },
          ),
        ),
      ),
    );
  }
}
