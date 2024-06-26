/// Data class that defines a crossword configuration.
library;

import 'package:equatable/equatable.dart';

/// {@template crossword_chunk_index}
/// Represents the position of a chunk in a crossword.
///
/// The chunks are indexed by (row, column) and (0,0) lies at the top-left,
/// hence only positive values are expected.
/// {@endtemplate}
typedef CrosswordChunkIndex = (int, int);

/// {@template crossword_chunk_size}
/// Represents the size of a chunk in a crossword.
///
/// A chunk is a square in the crossword grid, that in-turn contains multiple
/// cells (squares) of the crossword. A letter fits in a single cell.
///
/// The size is represented by an int since a chunk is squared.
/// {@endtemplate}
typedef CrosswordChunkSize = int;

/// {@template crossword_configuration}
/// Represents the configuration data of a crossword.
///
/// Such configuration is specific to a crossword, since depending on its size
/// and layout the crossword may have more or less chunks.
///
/// The [chunkSize] is the size of each chunk in the crossword, and it is
/// expected to be at least as big as the largest word in the crossword. So that
/// the maximum word can't span more than two chunks.
/// {@endtemplate}
class CrosswordConfiguration extends Equatable {
  /// {@macro crossword_configuration}
  const CrosswordConfiguration({
    required this.bottomRight,
    required this.chunkSize,
  });

  /// The index of the top-left chunk of the crossword.
  static const CrosswordChunkIndex topLeft = (0, 0);

  /// The index of the bottom-left chunk of the crossword.
  ///
  /// Since the [topLeft] is (0,0), the bottom-right may be used to easily
  /// derive the number of chunks in the crossword.
  final CrosswordChunkIndex bottomRight;

  /// {@macro crossword_chunk_size}
  final CrosswordChunkSize chunkSize;

  @override
  List<Object?> get props => [bottomRight, chunkSize];
}
