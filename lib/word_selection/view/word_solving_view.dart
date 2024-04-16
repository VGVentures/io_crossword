import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/hint/view/hint_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSolvingView extends StatelessWidget {
  const WordSolvingView({
    required this.selectedWord,
    super.key,
  });

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return BlocListener<CrosswordBloc, CrosswordState>(
      listenWhen: (previous, current) {
        return previous.selectedWord?.solvedStatus !=
            current.selectedWord?.solvedStatus;
      },
      listener: (context, state) {
        if (state.selectedWord?.solvedStatus == WordStatus.solved) {
          context
              .read<WordSelectionBloc>()
              .add(const WordFocusedSuccessRequested());
        }
      },
      child: switch (layout) {
        IoLayoutData.large => WordSolvingLargeView(selectedWord),
        IoLayoutData.small => WordSolvingSmallView(selectedWord),
      },
    );
  }
}

@visibleForTesting
class WordSolvingLargeView extends StatelessWidget {
  @visibleForTesting
  const WordSolvingLargeView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(wordId: selectedWord.word.id),
        const SizedBox(height: 8),
        const Spacer(),
        Text(
          selectedWord.word.clue,
          style: IoCrosswordTextStyles.titleMD,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: GeminiHintButton()),
            SizedBox(width: 8),
            Expanded(child: _SubmitButton()),
          ],
        ),
      ],
    );
  }
}

@visibleForTesting
class WordSolvingSmallView extends StatefulWidget {
  @visibleForTesting
  const WordSolvingSmallView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

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
    return Column(
      children: [
        TopBar(wordId: widget.selectedWord.word.id),
        const SizedBox(height: 32),
        IoWordInput.alphabetic(
          length: widget.selectedWord.word.length,
          onWord: (value) {
            context.read<CrosswordBloc>().add(AnswerUpdated(value));
          },
          controller: _controller,
        ),
        const SizedBox(height: 24),
        Text(
          widget.selectedWord.word.clue,
          style: IoCrosswordTextStyles.titleMD,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: GeminiHintButton()),
            const SizedBox(width: 8),
            Expanded(
              child: _SubmitButton(controller: _controller),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({this.controller});

  /// The controller that holds the user's input.
  ///
  /// Is `null` on large layout since the input is currently being handled by
  /// the [CrosswordGame].
  // TODO(alestiago): Make non-nullable when the input is handled by the
  // [IoWordInput] even on large layout.
  // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6463469220
  final IoWordInputController? controller;

  void _onSubmit(BuildContext context) {
    context.read<CrosswordBloc>().add(const AnswerSubmitted());

    if (controller != null) {
      context
          .read<WordSelectionBloc>()
          .add(WordSolveAttempted(answer: controller!.word));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton(
      onPressed: () => _onSubmit(context),
      child: Text(l10n.submit),
    );
  }
}
