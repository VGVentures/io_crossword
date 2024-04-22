import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

/// {@template crossword_interactive_viewer}
/// An [InteractiveViewer] configured to show a crossword.
/// {@endtemplate}
class CrosswordInteractiveViewer extends StatefulWidget {
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
  State<CrosswordInteractiveViewer> createState() =>
      _CrosswordInteractiveViewerState();
}

class _CrosswordInteractiveViewerState
    extends State<CrosswordInteractiveViewer> {
  final _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedWord = context
        .select<WordSelectionBloc, SelectedWord?>((bloc) => bloc.state.word);

    return InteractiveViewer.builder(
      scaleEnabled: false,
      panEnabled: selectedWord == null,
      transformationController: _transformationController,
      builder: (context, quad) {
        return QuadScope(
          data: quad,
          child: widget.builder(context, quad),
        );
      },
    );
  }
}
