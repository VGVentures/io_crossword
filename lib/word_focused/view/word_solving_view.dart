import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/hint/view/hint_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSolvingDesktopView extends StatelessWidget {
  const WordSolvingDesktopView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CrosswordBloc, CrosswordState>(
      listenWhen: (previous, current) {
        final previousState = previous as CrosswordLoaded;
        final currentState = current as CrosswordLoaded;
        return currentState.selectedWord?.solvedStatus !=
            previousState.selectedWord?.solvedStatus;
      },
      listener: (context, state) {
        final loadedState = state as CrosswordLoaded;
        if (loadedState.selectedWord?.solvedStatus == WordStatus.solved) {
          context
              .read<WordFocusedBloc>()
              .add(const WordFocusedSuccessRequested());
        }
      },
      child: Column(
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
          const BottomPanel(),
        ],
      ),
    );
  }
}

class WordSolvingMobileView extends StatelessWidget {
  const WordSolvingMobileView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CrosswordBloc, CrosswordState>(
      listenWhen: (previous, current) {
        final previousState = previous as CrosswordLoaded;
        final currentState = current as CrosswordLoaded;
        return currentState.selectedWord?.solvedStatus !=
            previousState.selectedWord?.solvedStatus;
      },
      listener: (context, state) {
        final loadedState = state as CrosswordLoaded;
        if (loadedState.selectedWord?.solvedStatus == WordStatus.solved) {
          context
              .read<WordFocusedBloc>()
              .add(const WordFocusedSuccessRequested());
        }
      },
      child: Column(
        children: [
          TopBar(wordId: selectedWord.word.id),
          const SizedBox(height: 32),
          IoWordInput.alphabetic(
            length: selectedWord.word.answer.length,
            onWord: (value) {
              context.read<CrosswordBloc>().add(AnswerUpdated(value));
            },
          ),
          const SizedBox(height: 24),
          Text(
            selectedWord.word.clue,
            style: IoCrosswordTextStyles.titleMD,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const BottomPanel(),
        ],
      ),
    );
  }
}

class BottomPanel extends StatelessWidget {
  const BottomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WordFocusedBloc, WordFocusedState>(
      buildWhen: (previous, current) => previous.focus != current.focus,
      builder: (context, state) {
        return switch (state.focus) {
          WordSolvingFocus.word => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 6,
                  child: GeminiHintButton(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 10,
                  child: OutlinedButton(
                    onPressed: () => context.read<CrosswordBloc>().add(
                          const AnswerSubmitted(),
                        ),
                    child: Text(l10n.submit),
                  ),
                ),
              ],
            ),
          WordSolvingFocus.hint => const GeminiTextField(),
        };
      },
    );
  }
}
