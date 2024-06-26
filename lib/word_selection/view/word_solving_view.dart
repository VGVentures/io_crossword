import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
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
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);
    if (selectedWord == null) return const SizedBox.shrink();
    final isHintsEnabled =
        context.select((HintBloc bloc) => bloc.state.isHintsEnabled);

    return Column(
      children: [
        const WordSelectionTopBar(canSolveWord: true),
        const SizedBox(height: 32),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IncorrectAnswerText(),
              const SizedBox(height: 24),
              Text(
                selectedWord.word.clue,
                style: IoCrosswordTextStyles.desktop.body,
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
        const ErrorSection(),
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
class WordSolvingSmallView extends StatelessWidget {
  @visibleForTesting
  const WordSolvingSmallView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);

    if (selectedWord == null) return const SizedBox.shrink();

    final isHintsEnabled =
        context.select((HintBloc bloc) => bloc.state.isHintsEnabled);

    return Column(
      children: [
        const WordSelectionTopBar(canSolveWord: true),
        const SizedBox(height: 32),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: CrosswordInput(
            length: selectedWord.word.length,
            characters: selectedWord.word.solvedCharacters,
          ),
        ),
        const SizedBox(height: 16),
        const IncorrectAnswerText(),
        const SizedBox(height: 16),
        Text(
          selectedWord.word.clue,
          style: IoCrosswordTextStyles.desktop.body,
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
        const ErrorSection(),
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
class IncorrectAnswerText extends StatelessWidget {
  @visibleForTesting
  const IncorrectAnswerText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = context.select(
      (WordSelectionBloc bloc) => bloc.state.status,
    );

    return Text(
      status == WordSelectionStatus.incorrect
          ? context.l10n.incorrectAnswer
          : '',
      style: IoCrosswordTextStyles.mobile.body3
          .copyWith(color: theme.colorScheme.error),
      textAlign: TextAlign.center,
    );
  }
}

@visibleForTesting
class ErrorSection extends StatelessWidget {
  @visibleForTesting
  const ErrorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = context.select(
      (WordSelectionBloc bloc) =>
          bloc.state.status == WordSelectionStatus.failure,
    );

    if (!hasError) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Text(
          context.l10n.submitError,
          style: IoCrosswordTextStyles.mobile.body3
              .copyWith(color: theme.colorScheme.error),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

@visibleForTesting
class BottomPanel extends StatelessWidget {
  @visibleForTesting
  const BottomPanel({super.key});

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
