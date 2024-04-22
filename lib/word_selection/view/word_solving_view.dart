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

    return Column(
      children: [
        const WordSelectionTopBar(),
        const SizedBox(height: 32),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

                    return const SingleChildScrollView(child: HintsSection());
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
  final _controller = IoWordInputController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);
    if (selectedWord == null) return const SizedBox.shrink();

    return Column(
      children: [
        const WordSelectionTopBar(),
        const SizedBox(height: 32),
        IoWordInput.alphabetic(
          length: selectedWord.word.length,
          controller: _controller,
        ),
        const SizedBox(height: 24),
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

              return const SingleChildScrollView(child: HintsSection());
            },
          ),
        ),
        BottomPanel(controller: _controller),
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

    if (isHintModeActive) {
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
        const Flexible(
          child: GeminiHintButton(),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: SubmitButton(controller: controller),
        ),
      ],
    );
  }
}

@visibleForTesting
class SubmitButton extends StatelessWidget {
  @visibleForTesting
  const SubmitButton({super.key, this.controller});

  /// The controller that holds the user's input.
  ///
  /// Is `null` on large layout since the input is currently being handled by
  /// the [CrosswordGame].
  // TODO(alestiago): Make non-nullable when the input is handled by the
  // [IoWordInput] even on large layout.
  // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6463469220
  final IoWordInputController? controller;

  void _onSubmit(BuildContext context) {
    if (controller != null) {
      context
          .read<WordSelectionBloc>()
          .add(WordSolveAttempted(answer: controller!.word));
    }
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
