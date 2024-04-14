import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/hint/view/hint_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSolvingDesktopView extends StatelessWidget {
  const WordSolvingDesktopView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: GeminiHintButton(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.read<CrosswordBloc>().add(
                        const AnswerSubmitted(),
                      ),
                  child: Text(l10n.submit),
                ),
              ),
            ],
          ),
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
    final l10n = context.l10n;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: GeminiHintButton(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.read<CrosswordBloc>().add(
                        const AnswerSubmitted(),
                      ),
                  child: Text(l10n.submit),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
