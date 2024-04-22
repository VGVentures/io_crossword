import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class Crossword2View extends StatelessWidget {
  const Crossword2View({super.key});

  @override
  Widget build(BuildContext context) {
    const configuration = CrosswordConfiguration(
      bottomLeft: (45, 45),
      chunkSize: 20,
    );

    return CrosswordLayoutScope(
      data: CrosswordLayoutData.fromConfiguration(
        configuration: configuration,
        cellSize: const Size.square(50),
      ),
      child: CrosswordInteractiveViewer(
        builder: (_, __) => const _CrosswordStack(configuration: configuration),
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
        index.$1 * crosswordLayout.chunkSize.width,
        index.$2 * crosswordLayout.chunkSize.height,
        crosswordLayout.chunkSize.width,
        crosswordLayout.chunkSize.height,
      );
      return chunkRect.overlaps(viewport);
    }

    final visibleChunks = <CrosswordChunkIndex>{
      // TODO(alestiago): Instead of computing the visiblity naively, we should
      // use the points to derive the visible chunks in O(1).
      // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6487319379
      for (var row = 0; row <= configuration.bottomLeft.$1; row++)
        for (var column = 0; column <= configuration.bottomLeft.$2; column++)
          if (isChunkVisible((row, column))) (row, column),
    };
    for (final chunk in visibleChunks) {
      context.read<CrosswordBloc>().add(BoardSectionRequested(chunk));
    }

    return SizedBox.fromSize(
      size: crosswordLayout.crosswordSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final chunk in visibleChunks)
            Positioned(
              key: ValueKey(chunk),
              left: chunk.$1 * crosswordLayout.chunkSize.width,
              top: chunk.$2 * crosswordLayout.chunkSize.height,
              child: CrosswordChunk(index: chunk),
            ),
          if (layout == IoLayoutData.large)
            BlocSelector<WordSelectionBloc, WordSelectionState, SelectedWord?>(
              selector: (state) => state.word,
              builder: (context, selectedWord) {
                if (selectedWord == null ||
                    selectedWord.word.solvedTimestamp != null) {
                  return const SizedBox.shrink();
                }

                final word = selectedWord.word;
                return Positioned(
                  left: (selectedWord.section.$1 *
                          crosswordLayout.chunkSize.width) +
                      (word.position.x * crosswordLayout.cellSize.width),
                  top: (selectedWord.section.$2 *
                          crosswordLayout.chunkSize.height) +
                      (word.position.y * crosswordLayout.cellSize.height),
                  child: IoWordInput.alphabetic(
                    key: ValueKey(selectedWord.word.id),
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
