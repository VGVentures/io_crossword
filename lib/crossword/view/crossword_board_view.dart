import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordBoardView extends StatelessWidget {
  const CrosswordBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (sectionSize, bottomRight, zoomLimit) =
        context.select<CrosswordBloc, (int, (int, int), double)>(
      (bloc) => (
        bloc.state.sectionSize,
        bloc.state.bottomRight,
        bloc.state.zoomLimit,
      ),
    );

    final configuration = CrosswordConfiguration(
      bottomRight: bottomRight,
      chunkSize: sectionSize,
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
          zoomLimit: zoomLimit,
          builder: (_, __) => _CrosswordStack(
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
              child: CrosswordChunk(
                index: chunk,
                chunkSize: configuration.chunkSize,
              ),
            ),
          BlocSelector<WordSelectionBloc, WordSelectionState, SelectedWord?>(
            selector: (state) => state.word,
            builder: (context, selectedWord) {
              return selectedWord != null
                  ? const CrosswordBackdrop()
                  : const SizedBox.shrink();
            },
          ),
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
                    : _WordInput(word: word),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WordInput extends StatelessWidget {
  const _WordInput({required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);
    final theme = Theme.of(context);

    final readOnly = context.select<WordSelectionBloc, bool>(
      (bloc) =>
          bloc.state.status == WordSelectionStatus.empty ||
          bloc.state.status == WordSelectionStatus.preSolving,
    );

    if (readOnly || layout == IoLayoutData.small) {
      return IoWord(
        word.answer,
        direction: word.axis.toAxis(),
        style: theme.io.wordTheme.big.copyWith(
          borderRadius: BorderRadius.zero,
          margin: theme.io.wordInput.secondary.padding,
          boxSize: theme.io.wordInput.secondary.filled.size,
          backgroundColor: theme.io.crosswordLetterTheme.empty.backgroundColor,
          textStyle: theme.io.crosswordLetterTheme.empty.textStyle,
        ),
      );
    }

    return CrosswordInput(
      key: ValueKey(word.id),
      style: theme.io.wordInput.secondary,
      direction: word.axis.toAxis(),
      length: word.length,
      characters: word.solvedCharacters,
    );
  }
}

extension on Quad {
  Rect toRect() => Rect.fromLTRB(point0.x, point0.y, point2.x, point2.y);
}

extension on WordAxis {
  Axis toAxis() =>
      this == WordAxis.horizontal ? Axis.horizontal : Axis.vertical;
}

extension on Mascots {
  IoWordStyle toIoWordStyle(ThemeData theme) {
    return theme.io.wordTheme.big.copyWith(
      borderRadius: BorderRadius.zero,
      margin: theme.io.wordInput.secondary.padding,
      boxSize: theme.io.wordInput.secondary.filled.size,
      textStyle: switch (this) {
        Mascots.dash => theme.io.crosswordLetterTheme.dash.textStyle,
        Mascots.sparky => theme.io.crosswordLetterTheme.sparky.textStyle,
        Mascots.dino => theme.io.crosswordLetterTheme.dino.textStyle,
        Mascots.android => theme.io.crosswordLetterTheme.android.textStyle,
      },
      backgroundColor: switch (this) {
        Mascots.dash => theme.io.crosswordLetterTheme.dash.backgroundColor,
        Mascots.sparky => theme.io.crosswordLetterTheme.sparky.backgroundColor,
        Mascots.dino => theme.io.crosswordLetterTheme.dino.backgroundColor,
        Mascots.android =>
          theme.io.crosswordLetterTheme.android.backgroundColor,
      },
    );
  }
}
