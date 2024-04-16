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
    if (selectedWord == null) return const SizedBox.shrink();

    final body = _WordSelectionBody(selectedWord: selectedWord);

    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.large => WordSelectionLargeContainer(child: body),
      IoLayoutData.small => WordSelectionSmallContainer(child: body),
    };
  }
}

class WordSelectionLargeContainer extends StatelessWidget {
  @visibleForTesting
  const WordSelectionLargeContainer({
    required this.child,
    super.key,
  });

  static const widthRatio = 0.35;

  final Widget child;

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
        child: child,
      ),
    );
  }
}

@visibleForTesting
class WordSelectionSmallContainer extends StatelessWidget {
  @visibleForTesting
  const WordSelectionSmallContainer({
    required this.child,
    super.key,
  });

  final Widget child;

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
          child: child,
        ),
      ),
    );
  }
}

class _WordSelectionBody extends StatelessWidget {
  const _WordSelectionBody({required this.selectedWord});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WordSelectionBloc, WordSelectionState,
        WordSelectionStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        // coverage:ignore-start
        final view = switch (status) {
          WordSelectionStatus.preSolving =>
            WordPreSolvingView(selectedWord: selectedWord),
          WordSelectionStatus.validating ||
          WordSelectionStatus.incorrect ||
          WordSelectionStatus.failure ||
          WordSelectionStatus.solving =>
            WordSolvingView(selectedWord: selectedWord),
          WordSelectionStatus.solved =>
            WordSuccessView(selectedWord: selectedWord),
          WordSelectionStatus.empty => const SizedBox.shrink(),
        };
        // coverage:ignore-end
        return view;
      },
    );
  }
}
