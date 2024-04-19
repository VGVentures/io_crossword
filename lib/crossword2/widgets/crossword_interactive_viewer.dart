import 'package:flutter/widgets.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

/// {@template crossword_interactive_viewer}
/// An [InteractiveViewer] configured to show a crossword.
/// {@endtemplate}
class CrosswordInteractiveViewer extends StatelessWidget {
  /// {@macro crossword_interactive_viewer}
  const CrosswordInteractiveViewer({
    required this.builder,
    super.key,
  });

  /// The builder for the [InteractiveViewer].
  ///
  /// The [Quad] defines the current viewport, and it can be accessed using
  /// [QuadScope.of].
  ///
  /// See also:
  ///
  /// * [QuadScope], which provides the [Quad] to its descendants.
  /// * [InteractiveViewer.builder], which is used to build the
  /// [InteractiveViewer].
  final InteractiveViewerWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer.builder(
      scaleEnabled: false,
      builder: (context, position) {
        return QuadScope(
          data: position,
          child: builder(context, position),
        );
      },
    );
  }
}
