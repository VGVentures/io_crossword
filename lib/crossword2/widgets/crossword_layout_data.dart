import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword/crossword2/widgets/widgets.dart';

/// {@template crossword_layout_data}
/// Defines data about the layout of a crossword.
///
/// See also:
///
/// * [CrosswordConfiguration], which defines the configuration of a crossword.
/// {@endtemplate}
class CrosswordLayoutData extends Equatable {
  /// {@macro crossword_layout_data}
  @visibleForTesting
  const CrosswordLayoutData({
    required this.cellSize,
    required this.chunkSize,
    required this.crosswordSize,
  });

  /// Derives a [CrosswordLayoutData] from a [CrosswordConfiguration] and a cell
  /// size.
  ///
  /// The [cellSize] is the size of a single cell in the crossword grid. A cell
  /// can be empty or contain a single letter.
  factory CrosswordLayoutData.fromConfiguration({
    required CrosswordConfiguration configuration,
    required Size cellSize,
  }) {
    final chunkSize = Size(
      cellSize.width * configuration.chunkSize,
      cellSize.height * configuration.chunkSize,
    );
    final crosswordSize = Size(
      chunkSize.width * (configuration.bottomRight.$1 + 1),
      chunkSize.height * (configuration.bottomRight.$2 + 1),
    );

    return CrosswordLayoutData(
      cellSize: cellSize,
      chunkSize: chunkSize,
      crosswordSize: crosswordSize,
    );
  }

  /// The size of a single cell in the crossword grid.
  final Size cellSize;

  /// The size of a single chunk in the crossword grid.
  final Size chunkSize;

  /// The total size of the crossword grid.
  final Size crosswordSize;

  @override
  List<Object?> get props => [cellSize, chunkSize, crosswordSize];
}

/// {@template crossword_layout_scope}
/// A widget that provides a [CrosswordLayoutData] to its descendants.
///
/// See also:
///
/// * [CrosswordLayoutData], which defines the layout data of a crossword.
/// {@endtemplate}
class CrosswordLayoutScope extends InheritedWidget {
  /// {@macro crossword_layout_scope}
  const CrosswordLayoutScope({
    required this.data,
    required super.child,
    super.key,
  });

  /// {@macro crossword_layout_data}
  final CrosswordLayoutData data;

  /// Retrieves the [CrosswordLayoutData] from the nearest ancestor
  /// [CrosswordLayoutScope].
  ///
  /// If there is no [CrosswordLayoutScope] in the given [context], this will
  /// throw an exception.
  static CrosswordLayoutData of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<CrosswordLayoutScope>();
    assert(result != null, 'No $CrosswordLayoutScope found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(covariant CrosswordLayoutScope oldWidget) =>
      data != oldWidget.data;
}
