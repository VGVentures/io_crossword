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
      (CrosswordBloc bloc) => (bloc.state as CrosswordLoaded).selectedWord,
    );
    if (selectedWord == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      key: ValueKey(selectedWord.word.id),
      create: (_) => WordFocusedBloc(),
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
        child: BlocBuilder<WordFocusedBloc, WordFocusedState>(
          builder: (context, state) {
            return switch (state.status) {
              WordFocusedStatus.clue => WordClueDesktopView(selectedWord),
              WordFocusedStatus.solving => WordSolvingDesktopView(selectedWord),
              WordFocusedStatus.success => WordSuccessDesktopView(selectedWord),
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
      (CrosswordBloc bloc) => (bloc.state as CrosswordLoaded).selectedWord,
    );
    if (selectedWord == null) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      key: ValueKey(selectedWord.word.id),
      create: (_) => WordFocusedBloc(),
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
          child: BlocBuilder<WordFocusedBloc, WordFocusedState>(
            builder: (context, state) {
              return switch (state.status) {
                WordFocusedStatus.clue => WordClueMobileView(selectedWord),
                WordFocusedStatus.solving =>
                  WordSolvingMobileView(selectedWord),
                WordFocusedStatus.success =>
                  WordSuccessMobileView(selectedWord),
              };
            },
          ),
        ),
      ),
    );
  }
}
