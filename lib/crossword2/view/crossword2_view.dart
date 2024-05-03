import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as domain show Axis, Mascots;
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
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

    final extendedViewport = EdgeInsets.symmetric(
      horizontal: crosswordLayout.chunkSize.width,
      vertical: crosswordLayout.chunkSize.height,
    ).inflateRect(viewport);

    Rect getChunkRect(CrosswordChunkIndex index) {
      return Rect.fromLTWH(
        (index.$1 * crosswordLayout.chunkSize.width) +
            crosswordLayout.padding.left,
        (index.$2 * crosswordLayout.chunkSize.height) +
            crosswordLayout.padding.top,
        crosswordLayout.chunkSize.width,
        crosswordLayout.chunkSize.height,
      );
    }

    bool isChunkVisible(CrosswordChunkIndex index) {
      final chunkRect = getChunkRect(index);
      return chunkRect.overlaps(viewport);
    }

    bool shouldChunkBeLoaded(CrosswordChunkIndex index) {
      final chunkRect = getChunkRect(index);
      return chunkRect.overlaps(extendedViewport);
    }

    // Chunks that are in the extendedViewport
    final loadedChunks = <CrosswordChunkIndex>{
      for (var row = 0; row <= configuration.bottomRight.$1; row++)
        for (var column = 0; column <= configuration.bottomRight.$2; column++)
          if (shouldChunkBeLoaded((row, column))) (row, column),
    };

    final visibleChunks = <CrosswordChunkIndex>{
      for (final loadedChunk in loadedChunks)
        if (isChunkVisible(loadedChunk)) loadedChunk,
    };

    context.read<CrosswordBloc>().add(LoadedSectionsSuspended(loadedChunks));

    for (final chunk in loadedChunks) {
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
                          direction: word.axis.toAxis(),
                          style: word.mascot!.toIoWordStyle(theme),
                        )
                      : CrosswordInput(
                          key: ValueKey(selectedWord.word.id),
                          style: theme.io.wordInput.secondary,
                          direction: word.axis.toAxis(),
                          length: selectedWord.word.length,
                          characters: selectedWord.word.solvedCharacters,
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

extension on domain.Mascots {
  IoWordStyle toIoWordStyle(ThemeData theme) {
    return theme.io.wordTheme.big.copyWith(
      borderRadius: BorderRadius.zero,
      margin: theme.io.wordInput.secondary.padding,
      boxSize: theme.io.wordInput.secondary.filled.size,
      textStyle: switch (this) {
        domain.Mascots.dash => theme.io.crosswordLetterTheme.dash.textStyle,
        domain.Mascots.sparky => theme.io.crosswordLetterTheme.sparky.textStyle,
        domain.Mascots.dino => theme.io.crosswordLetterTheme.dino.textStyle,
        domain.Mascots.android =>
          theme.io.crosswordLetterTheme.android.textStyle,
      },
      backgroundColor: switch (this) {
        domain.Mascots.dash =>
          theme.io.crosswordLetterTheme.dash.backgroundColor,
        domain.Mascots.sparky =>
          theme.io.crosswordLetterTheme.sparky.backgroundColor,
        domain.Mascots.dino =>
          theme.io.crosswordLetterTheme.dino.backgroundColor,
        domain.Mascots.android =>
          theme.io.crosswordLetterTheme.android.backgroundColor,
      },
    );
  }
}
