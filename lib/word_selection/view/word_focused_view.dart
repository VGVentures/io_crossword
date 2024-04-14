import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSelectedView extends StatelessWidget {
  const WordSelectedView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return layout == IoLayoutData.large
        ? const WordFocusedDesktopPage()
        : const WordFocusedMobilePage();
  }
}

@visibleForTesting
class WordFocusedDesktopPage extends StatelessWidget {
  @visibleForTesting
  const WordFocusedDesktopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord = context.select(
      (CrosswordBloc bloc) => bloc.state.selectedWord,
    );
    if (selectedWord == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      key: ValueKey(selectedWord.word.id),
      create: (_) => WordSelectionBloc(),
      child: WordFocusedDesktopView(selectedWord),
    );
  }
}

class WordFocusedDesktopView extends StatelessWidget {
  const WordFocusedDesktopView(this.selectedWord, {super.key});

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
                WordClueDesktopView(selectedWord),
              WordSelectionStatus.validating ||
              WordSelectionStatus.incorrect ||
              WordSelectionStatus.failure ||
              WordSelectionStatus.solving =>
                WordSolvingDesktopView(selectedWord),
              WordSelectionStatus.solved =>
                WordSuccessDesktopView(selectedWord),
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
class WordFocusedMobilePage extends StatelessWidget {
  @visibleForTesting
  const WordFocusedMobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord = context.select(
      (CrosswordBloc bloc) => bloc.state.selectedWord,
    );
    if (selectedWord == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      key: ValueKey(selectedWord.word.id),
      create: (_) => WordSelectionBloc(),
      child: WordFocusedMobileView(selectedWord),
    );
  }
}

class WordFocusedMobileView extends StatelessWidget {
  const WordFocusedMobileView(this.selectedWord, {super.key});

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
                  WordClueMobileView(selectedWord),
                WordSelectionStatus.validating ||
                WordSelectionStatus.incorrect ||
                WordSelectionStatus.failure ||
                WordSelectionStatus.solving =>
                  WordSolvingMobileView(selectedWord),
                WordSelectionStatus.solved =>
                  WordSuccessMobileView(selectedWord),
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
