import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    final layout = CrosswordLayoutScope.of(context);

    final chunk = SizedBox.fromSize(
      size: layout.chunkSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (debug)
            Text(
              '$index',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
        ],
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
