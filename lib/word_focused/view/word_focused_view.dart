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
            return switch (state) {
              WordFocusedState.clue => WordClueDesktopView(selectedWord),
              WordFocusedState.solving => WordSolvingDesktopView(selectedWord),
              WordFocusedState.success => WordSuccessDesktopView(selectedWord),
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

class WordFocusedMobileView extends StatefulWidget {
  const WordFocusedMobileView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  State<WordFocusedMobileView> createState() => _WordFocusedMobileViewState();
}

class _WordFocusedMobileViewState extends State<WordFocusedMobileView> {
  late final DraggableScrollableController _controller;

  @override
  void initState() {
    _controller = DraggableScrollableController();
    super.initState();
  }

  static const _minBottomSheetSize = 0.3;
  static const _maxBottomSheetSize = 0.92;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: _minBottomSheetSize,
      minChildSize: _minBottomSheetSize,
      maxChildSize: _maxBottomSheetSize,
      builder: (context, scrollController) {
        return ColoredBox(
          color: IoCrosswordColors.darkGray,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: BlocConsumer<WordFocusedBloc, WordFocusedState>(
                listener: (context, state) {
                  if (state == WordFocusedState.solving) {
                    _controller.animateTo(
                      .92,
                      duration: Durations.medium2,
                      curve: Curves.easeInOut,
                    );
                  }
                },
                builder: (context, state) {
                  return switch (state) {
                    WordFocusedState.clue =>
                      WordClueMobileView(widget.selectedWord),
                    WordFocusedState.solving =>
                      WordSolvingMobileView(widget.selectedWord),
                    WordFocusedState.success =>
                      WordSuccessMobileView(widget.selectedWord),
                  };
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
