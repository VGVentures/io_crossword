import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as domain;
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
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

  late AnimationController _animationController;

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

  @visibleForTesting
  double get maxScale => _maxScale;

  @visibleForTesting
  double get currentScale =>
      _transformationController.value.getMaxScaleOnAxis().roundTo(3);

  void _onAnimateTransformation() {
    _transformationController.value = _transformationAnimation!.value;
  }

  void _zoom(double value, BuildContext context) {
    final animationController = _animationController;
    if (animationController.isAnimating) return;

    final viewport = _viewport;
    if (viewport == null) return;

    final layout = IoLayout.of(context);
    final viewportSize = viewport.reduced(layout);

    final scaleEnd = currentScale + value;

    if (scaleEnd < widget.zoomLimit || scaleEnd > _maxScale) return;

    final desiredScale = scaleEnd / currentScale;

    final viewportCenter = Offset(
      viewportSize.width / 2,
      viewportSize.height / 2,
    );

    final beginOffset = _transformationController.toScene(viewportCenter);

    final newTransformation = Matrix4.copy(_transformationController.value)
      ..scale(desiredScale);

    final inverseMatrix = Matrix4.inverted(newTransformation);
    final untransformed = inverseMatrix.transform3(
      Vector3(
        viewportCenter.dx,
        viewportCenter.dy,
        0,
      ),
    );
    final endOffset = Offset(untransformed.x, untransformed.y);
    final dx = beginOffset.dx - endOffset.dx;
    final dy = beginOffset.dy - endOffset.dy;

    newTransformation.translate(-dx, -dy);

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

    final requiredWordSize =
        selectedWord.word.size(crosswordLayout) * _idealScale;

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

    final endWordSize = selectedWord.word.size(crosswordLayout) * scaleEnd;
    final endWordRect = selectedWord.offset(crosswordLayout) & endWordSize;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelectedSection(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transformationController = DefaultTransformationController.of(context);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
              Positioned(
                bottom: 120,
                right: 20,
                child: ZoomControls(
                  zoomInPressed: () => _zoomIn(context),
                  zoomOutPressed: () => _zoomOut(context),
                ),
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
          height * 0.7,
        ),
      IoLayoutData.large => Size(
          width * (1 - WordSelectionLargeContainer.widthRatio),
          height,
        ),
    };
  }

  double get width => point2.x - point0.x;

  double get height => point2.y - point0.y;
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

extension on domain.Word {
  /// The size of the word in the crossword.
  Size size(CrosswordLayoutData layout) {
    return switch (axis) {
      domain.Axis.horizontal => Size(
          length * layout.cellSize.width,
          layout.cellSize.height,
        ),
      domain.Axis.vertical => Size(
          layout.cellSize.width,
          length * layout.cellSize.height,
        ),
    };
  }
}

extension on double {
  double roundTo(int digits) => double.parse(toStringAsFixed(digits));
}
