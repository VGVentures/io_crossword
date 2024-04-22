import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as domain;
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:vector_math/vector_math_64.dart';

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

class _CrosswordInteractiveViewerState extends State<CrosswordInteractiveViewer>
    with SingleTickerProviderStateMixin {
  /// The latest viewport reported by the [InteractiveViewer.builder].
  Quad? _viewport;

  /// The [TransformationController] used to control the [InteractiveViewer].
  final _transformationController = TransformationController();

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  )..addListener(_onAnimate);
  late Animation<Vector3> _translationAnimation;

  void _onAnimate() {
    _transformationController.value =
        Matrix4.translation(_translationAnimation.value);
  }

  void _centerSelectedWord(BuildContext context) {
    final selectedWord = context.read<WordSelectionBloc>().state.word;
    final viewport = _viewport;
    if (selectedWord == null || viewport == null) return;

    final crosswordLayout = CrosswordLayoutScope.of(context);
    final wordMiddlePosition = selectedWord.word.middlePosition();

    _translationAnimation = Tween(
      begin: _transformationController.value.getTranslation(),
      end: viewport.center -
          Vector3(
            (selectedWord.section.$1 * crosswordLayout.chunkSize.width) +
                (wordMiddlePosition.$1 * crosswordLayout.cellSize.width),
            (selectedWord.section.$2 * crosswordLayout.chunkSize.height) +
                (wordMiddlePosition.$2 * crosswordLayout.cellSize.height),
            0,
          ),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.decelerate,
      ),
    );
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WordSelectionBloc, WordSelectionState>(
      listenWhen: (previous, current) =>
          previous.word != current.word && current.word != null,
      listener: (context, state) => _centerSelectedWord(context),
      child: BlocBuilder<WordSelectionBloc, WordSelectionState>(
        buildWhen: (previous, current) {
          return (previous.word != null) != (current.word != null);
        },
        builder: (context, state) {
          return InteractiveViewer.builder(
            scaleEnabled: false,
            panEnabled: state.word == null,
            transformationController: _transformationController,
            builder: (context, quad) {
              _viewport = quad;
              _centerSelectedWord(context);

              return QuadScope(
                data: quad,
                child: widget.builder(context, quad),
              );
            },
          );
        },
      ),
    );
  }
}

extension on Quad {
  Vector3 get center => (point2 - point0) / 2;
}

extension on domain.Word {
  (num, num) middlePosition() {
    return switch (axis) {
      domain.Axis.horizontal => (position.x + (length / 2), position.y),
      domain.Axis.vertical => (position.x, position.y + (length / 2)),
    };
  }
}
