import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordFocusedView extends StatelessWidget {
  const WordFocusedView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord = context.select(
      (CrosswordBloc bloc) => (bloc.state as CrosswordLoaded).selectedWord,
    );
    if (selectedWord == null) {
      return const SizedBox.shrink();
    }

    return WordFocusedDesktopView(selectedWord);
  }
}

class WordFocusedDesktopView extends StatelessWidget {
  @visibleForTesting
  const WordFocusedDesktopView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final offset = selectedWord.word.axis == Axis.horizontal
        ? const Offset(0, 180)
        : const Offset(250, 0);

    return Center(
      child: Transform.translate(
        offset: offset,
        child: Container(
          height: 268,
          width: 390,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: IoCrosswordColors.seedWhite,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    // TODO(any): Open share page
                    onPressed: () {}, // coverage:ignore-line
                    icon: const Icon(Icons.ios_share),
                  ),
                  Text(
                    selectedWord.word.id,
                    style: IoCrosswordTextStyles.labelMD.bold,
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<CrosswordBloc>().add(const WordUnselected());
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                selectedWord.word.clue,
                style: IoCrosswordTextStyles.titleMD,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Spacer(),
              Text(
                l10n.typeToAnswer,
                style: IoCrosswordTextStyles.bodyLG.copyWith(
                  color: IoCrosswordColors.accessibleGrey,
                ),
              ),
              const Spacer(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PrimaryButton(
                      // TODO(any): Get hint
                      onPressed: () {}, // coverage:ignore-line
                      label: l10n.getHint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      // TODO(any): Submit answer
                      onPressed: () {}, // coverage:ignore-line
                      label: l10n.submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordFocusedViewMobile extends StatelessWidget {
  const WordFocusedViewMobile(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: IoCrosswordColors.seedWhite,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                // TODO(any): Open share page
                onPressed: () {}, // coverage:ignore-line
                icon: const Icon(Icons.ios_share),
              ),
              Text(
                selectedWord.word.id,
                style: IoCrosswordTextStyles.labelMD.bold,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cancel),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            selectedWord.word.clue,
            style: IoCrosswordTextStyles.titleMD,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Spacer(),
          Text(
            l10n.typeToAnswer,
            style: IoCrosswordTextStyles.bodyLG.copyWith(
              color: IoCrosswordColors.accessibleGrey,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PrimaryButton(
                  // TODO(any): Get hint
                  onPressed: () {}, // coverage:ignore-line
                  label: l10n.getHint,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  // TODO(any): Submit answer
                  onPressed: () {}, // coverage:ignore-line
                  label: l10n.submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
