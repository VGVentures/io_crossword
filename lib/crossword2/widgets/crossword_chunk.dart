import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

/// {@template crossword_chunk}
/// A chunk of a crossword puzzle.
///
/// A chunk is a squared section of a crossword puzzle that contains some
/// cells.
/// {@endtemplate}
class CrosswordChunk extends StatelessWidget {
  const CrosswordChunk({
    required this.index,
    this.debug = kDebugMode,
    super.key,
  });

  /// {@macro crossword_chunk_index}
  final CrosswordChunkIndex index;

  /// Whether to show debug information or not.
  ///
  /// When enabled, the chunk will display its index at the top-left corner and
  /// it will border itself with a red border.
  ///
  /// Defaults to [kDebugMode].
  final bool debug;

  @visibleForTesting
  static const debugBorderKey = Key('CrosswordChunk.debugBorder');

  @override
  Widget build(BuildContext context) {
    final crosswordLayout = CrosswordLayoutScope.of(context);

    final chunk = SizedBox.fromSize(
      size: crosswordLayout.chunkSize,
      child: BlocSelector<CrosswordBloc, CrosswordState, BoardSection?>(
        selector: (state) => state.sections[index],
        builder: (context, chunk) {
          if (chunk == null) {
            return debug
                ? _DebugChunkIndexText(index: index)
                : const SizedBox();
          }

          final letters = CrosswordLetterData.fromChunk(chunk);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              for (final letter in letters.values)
                Positioned(
                  left: letter.index.$1 * crosswordLayout.cellSize.width,
                  top: letter.index.$2 * crosswordLayout.cellSize.height,
                  child: CrosswordLetter(data: letter),
                ),
              if (debug) _DebugChunkIndexText(index: index),
            ],
          );
        },
      ),
    );

    return debug
        ? DecoratedBox(
            key: debugBorderKey,
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: chunk,
          )
        : chunk;
  }
}

class _DebugChunkIndexText extends StatelessWidget {
  const _DebugChunkIndexText({required this.index});

  /// {@macro crossword_chunk_index}
  final CrosswordChunkIndex index;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$index',
      style: const TextStyle(color: Colors.red, fontSize: 12),
    );
  }
}
