import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordFocusedDesktopPage extends StatelessWidget {
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
            return switch (state.status) {
              WordSelectionStatus.preSolving =>
                WordClueDesktopView(selectedWord),
              WordSelectionStatus.solving ||
              WordSelectionStatus.validating ||
              WordSelectionStatus.incorrect ||
              WordSelectionStatus.failure =>
                WordSolvingDesktopView(selectedWord),
              WordSelectionStatus.solved =>
                WordSuccessDesktopView(selectedWord),
            };
          },
        ),
      ),
    );
  }
}

class WordFocusedMobilePage extends StatelessWidget {
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
              return switch (status) {
                WordSelectionStatus.preSolving =>
                  WordClueMobileView(selectedWord),
                WordSelectionStatus.solving ||
                WordSelectionStatus.validating ||
                WordSelectionStatus.incorrect ||
                WordSelectionStatus.failure =>
                  WordSolvingMobileView(selectedWord),
                WordSelectionStatus.solved =>
                  WordSuccessMobileView(selectedWord),
              };
            },
          ),
        ),
      ),
    );
  }
}
