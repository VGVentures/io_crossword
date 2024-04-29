import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as domain show Axis;
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class Crossword2View extends StatelessWidget {
  const Crossword2View({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO(any): Retrieve the configuration from the `CrosswordBloc` instead of
    // hard-coding it:
    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6529725788
    const configuration = CrosswordConfiguration(
      bottomRight: (45, 45),
      chunkSize: 20,
    );

    return CrosswordLayoutScope(
      data: CrosswordLayoutData.fromConfiguration(
        configuration: configuration,
        cellSize: Size(
          theme.io.wordInput.secondary.empty.size.width +
              theme.io.wordInput.secondary.padding.horizontal,
          theme.io.wordInput.secondary.empty.size.height +
              theme.io.wordInput.secondary.padding.vertical,
        ),
      ),
      child: DefaultTransformationController(
        child: CrosswordInteractiveViewer(
          builder: (_, __) => const _CrosswordStack(
            configuration: configuration,
          ),
        ),
      ),
    );
  }
}

class _CrosswordStack extends StatelessWidget {
  const _CrosswordStack({required this.configuration});

  final CrosswordConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);
    final crosswordLayout = CrosswordLayoutScope.of(context);
    final quad = QuadScope.of(context);
    final viewport = quad.toRect();

    bool isChunkVisible(CrosswordChunkIndex index) {
      final chunkRect = Rect.fromLTWH(
        (index.$1 * crosswordLayout.chunkSize.width) +
            crosswordLayout.padding.left,
        (index.$2 * crosswordLayout.chunkSize.height) +
            crosswordLayout.padding.top,
        crosswordLayout.chunkSize.width,
        crosswordLayout.chunkSize.height,
      );
      return chunkRect.overlaps(viewport);
    }

    final visibleChunks = <CrosswordChunkIndex>{
      // TODO(alestiago): Instead of computing the visiblity naively, we should
      // use the points to derive the visible chunks in O(1).
      // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6487319379
      for (var row = 0; row <= configuration.bottomRight.$1; row++)
        for (var column = 0; column <= configuration.bottomRight.$2; column++)
          if (isChunkVisible((row, column))) (row, column),
    };
    for (final chunk in visibleChunks) {
      context.read<CrosswordBloc>().add(BoardSectionRequested(chunk));
    }

    return SizedBox.fromSize(
      size: crosswordLayout.padding.inflateSize(crosswordLayout.crosswordSize),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final chunk in visibleChunks)
            Positioned(
              key: ValueKey(chunk),
              left: (chunk.$1 * crosswordLayout.chunkSize.width) +
                  crosswordLayout.padding.left,
              top: (chunk.$2 * crosswordLayout.chunkSize.height) +
                  crosswordLayout.padding.top,
              child: CrosswordChunk(index: chunk),
            ),
          BlocSelector<WordSelectionBloc, WordSelectionState, SelectedWord?>(
            selector: (state) => state.word,
            builder: (context, selectedWord) {
              return selectedWord != null
                  ? const CrosswordBackdrop()
                  : const SizedBox.shrink();
            },
          ),
          if (layout == IoLayoutData.large)
            BlocSelector<WordSelectionBloc, WordSelectionState, SelectedWord?>(
              selector: (state) => state.word,
              builder: (context, selectedWord) {
                if (selectedWord == null) {
                  return const SizedBox.shrink();
                }

                final word = selectedWord.word;
                final theme = Theme.of(context);

                return Positioned(
                  left: (selectedWord.section.$1 *
                          crosswordLayout.chunkSize.width) +
                      (word.position.x * crosswordLayout.cellSize.width) +
                      crosswordLayout.padding.left,
                  top: (selectedWord.section.$2 *
                          crosswordLayout.chunkSize.height) +
                      (word.position.y * crosswordLayout.cellSize.height) +
                      crosswordLayout.padding.top,
                  child: selectedWord.word.isSolved
                      ? IoWord(
                          selectedWord.word.answer,
                          style: theme.io.wordTheme.big,
                        )
                      : CrosswordInput(
                          key: ValueKey(selectedWord.word.id),
                          style: theme.io.wordInput.secondary,
                          direction: word.axis.toAxis(),
                          length: selectedWord.word.length,
                        ),
                );
              },
            ),
        ],
      ),
    );
  }
}

extension on Quad {
  Rect toRect() => Rect.fromLTRB(point0.x, point0.y, point2.x, point2.y);
}

extension on domain.Axis {
  Axis toAxis() =>
      this == domain.Axis.horizontal ? Axis.horizontal : Axis.vertical;
}
