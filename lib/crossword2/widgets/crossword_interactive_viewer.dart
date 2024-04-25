import 'dart:math' as math;

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
  ///
  /// See also:
  ///
  /// * [DefaultTransformationController], which provides the
  /// [TransformationController] to its descendants.
  late TransformationController _transformationController;

  late AnimationController? _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  Animation<Vector3>? _translationAnimation;

  /// The minimum amount of translation allowed.
  final _minTranslation = Vector3.zero();

  /// The maximum amount of translation allowed.
  final _maxTranslation = Vector3.zero();

  void _onAnimateTranslation() {
    _transformationController.value =
        Matrix4.translation(_translationAnimation!.value);
  }

  void _centerSelectedWord(BuildContext context) {
    final animationController = _animationController;
    if (_animationController == null || _animationController!.isAnimating) {
      return;
    }

    final selectedWord = context.read<WordSelectionBloc>().state.word;
    final viewport = _viewport;
    if (selectedWord == null || viewport == null) return;

    final crosswordLayout = CrosswordLayoutScope.of(context);

    _maxTranslation.setValues(
      -(crosswordLayout.crosswordSize.width +
              crosswordLayout.padding.horizontal) +
          viewport.width,
      -(crosswordLayout.crosswordSize.height +
              crosswordLayout.padding.vertical) +
          viewport.height,
      0,
    );

    final wordMiddlePosition = selectedWord.word.middlePosition();

    final begin = _transformationController.value.getTranslation();
    final end = viewport.center -
        Vector3(
          (selectedWord.section.$1 * crosswordLayout.chunkSize.width) +
              (wordMiddlePosition.$1 * crosswordLayout.cellSize.width) +
              crosswordLayout.padding.left,
          (selectedWord.section.$2 * crosswordLayout.chunkSize.height) +
              (wordMiddlePosition.$2 * crosswordLayout.cellSize.height) +
              crosswordLayout.padding.top,
          0,
        );
    end
      ..x = math.max(
        math.min(end.x, _minTranslation.x),
        _maxTranslation.x,
      )
      ..y = math.max(
        math.min(end.y, _minTranslation.y),
        _maxTranslation.y,
      );
    if (begin == end) return;

    _translationAnimation?.removeListener(_onAnimateTranslation);
    _translationAnimation = Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Curves.decelerate,
      ),
    )..addListener(_onAnimateTranslation);
    animationController.forward(from: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transformationController = DefaultTransformationController.of(context);
  }

  @override
  void dispose() {
    _translationAnimation?.removeListener(_onAnimateTranslation);
    _translationAnimation = null;
    _animationController?.dispose();
    _animationController = null;

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

  double get width => point2.x - point0.x;

  double get height => point2.y - point0.y;
}

extension on domain.Word {
  (num, num) middlePosition() {
    return switch (axis) {
      domain.Axis.horizontal => (position.x + (length / 2), position.y),
      domain.Axis.vertical => (position.x, position.y + (length / 2)),
    };
  }
}
