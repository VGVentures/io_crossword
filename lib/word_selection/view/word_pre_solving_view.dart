import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template word_pre_solving_view}
/// Displays the selected word and allows the user to solve it, if it has not
/// already been solved.
/// {@endtemplate}
class WordPreSolvingView extends StatelessWidget {
  const WordPreSolvingView({
    required this.selectedWord,
    super.key,
  });

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.large => WordPreSolvingLargeView(selectedWord),
      IoLayoutData.small => WordPreSolvingSmallView(selectedWord),
    };
  }
}

@visibleForTesting
class WordPreSolvingLargeView extends StatelessWidget {
  @visibleForTesting
  const WordPreSolvingLargeView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final solved = selectedWord.solvedStatus == WordStatus.solved;

    return Column(
      children: [
        const WordSelectionTopBar(),
        const SizedBox(height: 8),
        const Spacer(),
        Text(
          selectedWord.word.clue,
          style: IoCrosswordTextStyles.titleMD,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        const SizedBox(height: 8),
        if (!solved) _SolveItButton(wordIdentifier: selectedWord.word.id),
      ],
    );
  }
}

@visibleForTesting
class WordPreSolvingSmallView extends StatelessWidget {
  @visibleForTesting
  const WordPreSolvingSmallView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final solved = selectedWord.solvedStatus == WordStatus.solved;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const WordSelectionTopBar(),
        const SizedBox(height: 24),
        Text(
          selectedWord.word.clue,
          style: IoCrosswordTextStyles.titleMD,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (!solved) _SolveItButton(wordIdentifier: selectedWord.word.id),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SolveItButton extends StatelessWidget {
  const _SolveItButton({
    required this.wordIdentifier,
  });

  final String wordIdentifier;

  void _onSolveIt(BuildContext context) {
    context.read<WordSelectionBloc>().add(const WordSolveRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton.icon(
      onPressed: () => _onSolveIt(context),
      icon: const Icon(Icons.edit),
      label: Text(l10n.solveIt),
    );
  }
}
