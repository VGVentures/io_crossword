import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSolvingView extends StatelessWidget {
  const WordSolvingView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.large => const WordSolvingLargeView(),
      IoLayoutData.small => const WordSolvingSmallView(),
    };
  }
}

@visibleForTesting
class WordSolvingLargeView extends StatelessWidget {
  @visibleForTesting
  const WordSolvingLargeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);
    if (selectedWord == null) return const SizedBox.shrink();
    final isHintsEnabled =
        context.select((HintBloc bloc) => bloc.state.isHintsEnabled);
    final isIncorrectAnswer = context.select(
      (WordSelectionBloc bloc) =>
          bloc.state.status == WordSelectionStatus.incorrect,
    );

    return Column(
      children: [
        const WordSelectionTopBar(),
        const SizedBox(height: 32),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isIncorrectAnswer ? context.l10n.incorrectAnswer : '',
                style: IoCrosswordTextStyles.bodyMD.medium
                    ?.copyWith(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 24),
              Text(
                selectedWord.word.clue,
                style: IoCrosswordTextStyles.titleMD,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Flexible(
                child: BlocSelector<WordSelectionBloc, WordSelectionState,
                    WordSelectionStatus>(
                  selector: (state) => state.status,
                  builder: (context, status) {
                    if (status == WordSelectionStatus.validating) {
                      return const CircularProgressIndicator();
                    }

                    return const HintsSection();
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (isHintsEnabled) ...[
          const HintsTitle(),
          const SizedBox(height: 32),
        ],
        const BottomPanel(),
      ],
    );
  }
}

@visibleForTesting
class WordSolvingSmallView extends StatefulWidget {
  @visibleForTesting
  const WordSolvingSmallView({super.key});

  @override
  State<WordSolvingSmallView> createState() => _WordSolvingSmallViewState();
}

class _WordSolvingSmallViewState extends State<WordSolvingSmallView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);
    if (selectedWord == null) return const SizedBox.shrink();
    final isHintsEnabled =
        context.select((HintBloc bloc) => bloc.state.isHintsEnabled);
    final isIncorrectAnswer = context.select(
      (WordSelectionBloc bloc) =>
          bloc.state.status == WordSelectionStatus.incorrect,
    );

    return Column(
      children: [
        const WordSelectionTopBar(),
        const SizedBox(height: 32),
        CrosswordInput(
          length: selectedWord.word.length,
          characters: selectedWord.word.solvedCharacters,
        ),
        const SizedBox(height: 16),
        Text(
          isIncorrectAnswer ? context.l10n.incorrectAnswer : '',
          style: IoCrosswordTextStyles.bodyMD.medium
              ?.copyWith(color: theme.colorScheme.error),
        ),
        const SizedBox(height: 16),
        Text(
          selectedWord.word.clue,
          style: IoCrosswordTextStyles.titleMD,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Expanded(
          child: BlocSelector<WordSelectionBloc, WordSelectionState,
              WordSelectionStatus>(
            selector: (state) => state.status,
            builder: (context, status) {
              if (status == WordSelectionStatus.validating) {
                return const Center(child: CircularProgressIndicator());
              }

              return const Align(
                alignment: Alignment.topCenter,
                child: HintsSection(),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        if (isHintsEnabled) ...[
          const HintsTitle(),
          const SizedBox(height: 32),
        ],
        const BottomPanel(),
      ],
    );
  }
}

@visibleForTesting
class BottomPanel extends StatelessWidget {
  @visibleForTesting
  const BottomPanel({super.key, this.controller});

  final IoWordInputController? controller;

  @override
  Widget build(BuildContext context) {
    final isHintModeActive =
        context.select((HintBloc bloc) => bloc.state.isHintModeActive);
    final isHintsEnabled =
        context.select((HintBloc bloc) => bloc.state.isHintsEnabled);

    if (isHintModeActive && isHintsEnabled) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CloseHintButton(),
          SizedBox(width: 8),
          Expanded(
            child: GeminiTextField(),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isHintsEnabled) ...[
          const Flexible(
            child: GeminiHintButton(),
          ),
          const SizedBox(width: 8),
        ],
        const Flexible(
          child: SubmitButton(),
        ),
      ],
    );
  }
}

@visibleForTesting
class SubmitButton extends StatelessWidget {
  @visibleForTesting
  const SubmitButton({super.key});

  void _onSubmit(BuildContext context) {
    final wordInputController = DefaultWordInputController.of(context);
    context
        .read<WordSelectionBloc>()
        .add(WordSolveAttempted(answer: wordInputController.word));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final wordSelectionStatus = context.select(
      (WordSelectionBloc bloc) => bloc.state.status,
    );
    final isValidating = wordSelectionStatus == WordSelectionStatus.validating;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 162),
      child: OutlinedButton(
        onPressed: isValidating ? null : () => _onSubmit(context),
        child: Text(l10n.submit),
      ),
    );
  }
}
