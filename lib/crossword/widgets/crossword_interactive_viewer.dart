import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template crossword_interactive_viewer}
/// An [InteractiveViewer] configured to show a crossword.
/// {@endtemplate}
class CrosswordInteractiveViewer extends StatefulWidget {
  /// {@macro crossword_interactive_viewer}
  const CrosswordInteractiveViewer({
    required this.builder,
    required this.zoomLimit,
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

  final double zoomLimit;

  @override
  State<CrosswordInteractiveViewer> createState() =>
      CrosswordInteractiveViewerState();
}

@visibleForTesting
class CrosswordInteractiveViewerState extends State<CrosswordInteractiveViewer>
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

  late final AnimationController _animationController;

  Animation<Matrix4>? _transformationAnimation;

  /// The minimum amount of translation allowed.
  final _minTranslation = Vector3.zero();

  /// The maximum amount of translation allowed.
  final _maxTranslation = Vector3.zero();

  /// The scale that should be used, whenever possible.
  ///
  /// It is assumed it is the identity of multiplication.
  final _idealScale = 1.0;

  /// The maximum scale to be used when the board is zoomed in.
  final _maxScale = 1.4;

  /// The padding added when scaling the selected word.
  final _padding = 20.0;

  @visibleForTesting
  double get maxScale => _maxScale;

  @visibleForTesting
  double get currentScale =>
      _transformationController.value.getMaxScaleOnAxis().roundTo(3);

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  void transform(Matrix4 transformation) {
    _transformationController.value = transformation;
  }

  void _onAnimateTransformation() {
    _transformationController.value = _transformationAnimation!.value;
  }

  Rect _getBoardBoundaries(BuildContext context) {
    final crosswordLayout = CrosswordLayoutScope.of(context);
    final boardWidth = crosswordLayout.padding.left +
        crosswordLayout.crosswordSize.width +
        crosswordLayout.padding.right;
    final boardHeight = crosswordLayout.padding.top +
        crosswordLayout.crosswordSize.height +
        crosswordLayout.padding.bottom;
    return Rect.fromLTRB(0, 0, boardWidth, boardHeight);
  }

  void _zoom(double value, BuildContext context) {
    final animationController = _animationController;
    if (animationController.isAnimating) return;

    final viewport = _viewport;
    if (viewport == null) return;

    final desiredScale = currentScale + value;
    final clampedScale = clampDouble(desiredScale, widget.zoomLimit, _maxScale);
    var scaleChange = clampedScale / currentScale;

    // Calculate the tentative viewport after zooming.
    final viewportCenter = viewport.center;
    final zoomedViewport = viewport.scaled(scaleChange);
    final end = zoomedViewport.center;
    var delta = end - viewportCenter;
    var newViewportRect = zoomedViewport.toRect().shift(-delta);

    final boundaries = _getBoardBoundaries(context);

    // If the tentative viewport does not fit in the board, update the zooming
    // level and recalculate the viewport to fit.
    if (!boundaries.fits(newViewportRect)) {
      final scaleRatio = newViewportRect.ratioToFitIn(boundaries);
      scaleChange *= scaleRatio;
      final fittedViewport = viewport.scaled(scaleChange);
      delta = fittedViewport.center - viewportCenter;
      newViewportRect = fittedViewport.toRect().shift(-delta);
    }

    // If the new viewport is not entirely within the boundaries, move it.
    if (!boundaries.containsComplete(newViewportRect)) {
      var (dx, dy) = (0.0, 0.0);

      if (newViewportRect.left < boundaries.left) {
        dx = boundaries.left - newViewportRect.left;
      }
      if (newViewportRect.top < boundaries.top) {
        dy = boundaries.top - newViewportRect.top;
      }
      if (newViewportRect.right > boundaries.right) {
        dx = boundaries.right - newViewportRect.right;
      }
      if (newViewportRect.bottom > boundaries.bottom) {
        dy = boundaries.bottom - newViewportRect.bottom;
      }

      delta -= Offset(dx, dy);
    }

    // Create the scale & translation transformation for the requested zoom.
    final newTransformation = _transformationController.value.clone()
      ..scale(scaleChange)
      ..translate(delta.dx, delta.dy);

    _playTransformation(
      _transformationController.value,
      newTransformation,
      animationController,
    );
  }

  void _zoomIn(BuildContext context) {
    _zoom(0.2, context);
  }

  void _zoomOut(BuildContext context) {
    _zoom(-0.2, context);
  }

  void _centerSelectedSection(BuildContext context) {
    final selectedWord = context.read<CrosswordBloc>().state.initialWord;

    if (selectedWord == null) return;

    final viewport = _viewport;
    if (viewport == null) return;

    final transformationEnd = _calculatorTransformationEnd(selectedWord);

    _transformationController.value =
        Matrix4.translation(transformationEnd.getTranslation());
  }

  void _centerSelectedWord(BuildContext context) {
    final animationController = _animationController;
    if (animationController.isAnimating) return;

    final selectedWord = context.read<WordSelectionBloc>().state.word;
    if (selectedWord == null) return;

    final viewport = _viewport;
    if (viewport == null) return;

    final transformationEnd = _calculatorTransformationEnd(selectedWord);

    _playTransformation(
      _transformationController.value,
      transformationEnd,
      animationController,
    );
  }

  Matrix4 _calculatorTransformationEnd(SelectedWord selectedWord) {
    final layout = IoLayout.of(context);
    final crosswordLayout = CrosswordLayoutScope.of(context);

    final viewport = _viewport!;

    _maxTranslation.setValues(
      -(crosswordLayout.crosswordSize.width +
              crosswordLayout.padding.horizontal) +
          viewport.width,
      -(crosswordLayout.crosswordSize.height +
              crosswordLayout.padding.vertical) +
          viewport.height,
      0,
    );

    final viewportSize = viewport.reduced(layout);
    final beginViewportSize = viewportSize * currentScale;

    final wordSize = selectedWord.word.size(crosswordLayout);
    final requiredWordSize =
        wordSize.addWordPadding(crosswordLayout, _padding) * _idealScale;

    final scaleEnd = math
        .min(
          beginViewportSize.width < requiredWordSize.width
              ? beginViewportSize.width / requiredWordSize.width
              : _idealScale,
          beginViewportSize.height < requiredWordSize.height
              ? beginViewportSize.height / requiredWordSize.height
              : _idealScale,
        )
        .roundTo(3);

    final endWordSize = wordSize * scaleEnd;
    final endWordRect =
        (selectedWord.offset(crosswordLayout) & endWordSize).inflate(_padding);
    final endWordCenter = endWordRect.center;

    final endViewportCenter = Vector3(
      (beginViewportSize.width / 2).roundTo(3),
      (beginViewportSize.height / 2).roundTo(3),
      0,
    );

    final translationEnd = endViewportCenter -
        Vector3(
          endWordCenter.dx,
          endWordCenter.dy,
          0,
        )
      ..scale(scaleEnd);
    translationEnd
      ..x = math.max(
        math.min(translationEnd.x, _minTranslation.x),
        _maxTranslation.x,
      )
      ..y = math.max(
        math.min(translationEnd.y, _minTranslation.y),
        _maxTranslation.y,
      );

    return Matrix4.translation(translationEnd)..scale(scaleEnd);
  }

  void _playTransformation(
    Matrix4 transformationBegin,
    Matrix4 transformationEnd,
    AnimationController animationController,
  ) {
    if (transformationBegin != transformationEnd) {
      _transformationAnimation?.removeListener(_onAnimateTransformation);
      _transformationAnimation = Matrix4Tween(
        begin: transformationBegin,
        end: transformationEnd,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.decelerate,
        ),
      )..addListener(_onAnimateTransformation);

      animationController.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelectedSection(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transformationController = DefaultTransformationController.of(context);
  }

  @override
  void dispose() {
    _transformationAnimation?.removeListener(_onAnimateTransformation);
    _transformationAnimation = null;
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordSelectionBloc, WordSelectionState>(
      buildWhen: (previous, current) =>
          previous.word != current.word || current.word == null,
      builder: (context, state) {
        final layout = IoLayout.of(context);
        return Stack(
          children: [
            InteractiveViewer.builder(
              minScale: widget.zoomLimit,
              maxScale: _maxScale,
              panEnabled: state.word == null,
              transformationController: _transformationController,
              builder: (context, quad) {
                _viewport = quad;

                if (state.word != null) {
                  _centerSelectedWord(context);
                }

                return QuadScope(
                  data: quad,
                  child: widget.builder(context, quad),
                );
              },
            ),
            if (layout == IoLayoutData.large)
              BlocSelector<CrosswordBloc, CrosswordState, bool>(
                selector: (state) => state.mascotVisible,
                builder: (context, mascotVisible) {
                  return mascotVisible
                      ? const SizedBox.shrink()
                      : Positioned(
                          bottom: 120,
                          right: 20,
                          child: ZoomControls(
                            zoomInPressed: () => _zoomIn(context),
                            zoomOutPressed: () => _zoomOut(context),
                          ),
                        );
                },
              ),
          ],
        );
      },
    );
  }
}

@visibleForTesting
class ZoomControls extends StatelessWidget {
  const ZoomControls({
    required this.zoomInPressed,
    required this.zoomOutPressed,
    super.key,
  });

  final VoidCallback zoomInPressed;
  final VoidCallback zoomOutPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        IconButton(
          style: theme.io.iconButtonTheme.filled,
          onPressed: zoomInPressed,
          icon: const Icon(Icons.add),
        ),
        const SizedBox(height: 10),
        IconButton(
          style: theme.io.iconButtonTheme.filled,
          onPressed: zoomOutPressed,
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }
}

extension on Quad {
  /// Determines the size of the visible area, when the
  /// [CrosswordInteractiveViewer] is obscured by other widgets.
  ///
  /// The widgets that obscure the quad are the [WordSelectionSmallContainer],
  /// in a small layout, or the [WordSelectionLargeContainer], in a large
  /// layout. They appear when a word is selected.
  Size reduced(IoLayoutData layout) {
    return switch (layout) {
      IoLayoutData.small => Size(
          width,
          height * 0.5,
        ),
      IoLayoutData.large => Size(
          width * (1 - WordSelectionLargeContainer.widthRatio),
          height,
        ),
    };
  }

  double get width => point2.x - point0.x;

  double get height => point2.y - point0.y;

  /// The center of the [Quad] in absolute coordinates.
  Offset get center => Offset(point0.x + width / 2, point0.y + height / 2);

  /// Converts the [Quad] into a [Rect] assuming it is a rectangle defined by
  /// `point0` as the top left and `point2` as the bottom right.
  Rect toRect() => Rect.fromLTRB(point0.x, point0.y, point2.x, point2.y);

  /// Returns a new [Quad] transformed scaling the current one by `scale`.
  Quad scaled(double scale) => Quad.copy(this)
    // We use the inverse of the scale because when the scale increases
    // the viewport is smaller.
    ..transform(Matrix4.identity().scaled(1 / scale));
}

extension on Rect {
  /// Whether the passed `rect` is contained entirely by `this`.
  bool containsComplete(Rect rect) {
    return rect.left >= left &&
        rect.top >= top &&
        rect.right <= right &&
        rect.bottom <= bottom;
  }

  /// Whether the passed `rect` can fit inside `this`.
  bool fits(Rect rect) {
    return rect.width <= width && rect.height <= height;
  }

  /// Scale ratio to fit `this` within `rect`.
  double ratioToFitIn(Rect rect) {
    if (rect.width >= width && rect.height >= height) {
      return 1;
    }

    final widthRatio = width / rect.width;
    final heightRatio = height / rect.height;
    final overflowRatio = math.max(widthRatio, heightRatio);

    return overflowRatio;
  }
}

extension on SelectedWord {
  /// Determines the absolute offset of the word in the crossword.
  ///
  /// The origin is based on the top-left corner of the crossword.
  Offset offset(CrosswordLayoutData layout) {
    final chunkOffset = Offset(
      (section.$1 * layout.chunkSize.width) + layout.padding.left,
      (section.$2 * layout.chunkSize.height) + layout.padding.top,
    );
    final wordOffset = Offset(
      word.position.x * layout.cellSize.width,
      word.position.y * layout.cellSize.height,
    );

    return chunkOffset + wordOffset;
  }
}

extension on Word {
  /// The size of the word in the crossword.
  Size size(CrosswordLayoutData layout) {
    return switch (axis) {
      WordAxis.horizontal => Size(
          length * layout.cellSize.width,
          layout.cellSize.height,
        ),
      WordAxis.vertical => Size(
          layout.cellSize.width,
          length * layout.cellSize.height,
        ),
    };
  }
}

extension on double {
  double roundTo(int digits) => double.parse(toStringAsFixed(digits));
}

extension on Size {
  Size addWordPadding(CrosswordLayoutData crosswordLayout, double padding) {
    if (width > height) {
      return Size(
        width + padding * 2,
        height,
      );
    } else {
      return Size(
        width,
        height + padding * 2,
      );
    }
  }
}
