import 'dart:math' as math;

import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' as domain;
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
    duration: const Duration(milliseconds: 900),
  );
  Animation<Matrix4>? _transformationAnimation;

  /// The minimum amount of translation allowed.
  final _minTranslation = Vector3.zero();

  /// The maximum amount of translation allowed.
  final _maxTranslation = Vector3.zero();

  /// The scale that should be used, whenever possible.
  ///
  /// It is assumed it is the identity of multiplication.
  final _idealScale = 1.0;

  void _onAnimateTransformation() {
    _transformationController.value = _transformationAnimation!.value;
  }

  void _centerSelectedWord(BuildContext context) {
    final animationController = _animationController;
    if (animationController == null) return;
    if (animationController.isAnimating) return;

    final selectedWord = context.read<WordSelectionBloc>().state.word;
    if (selectedWord == null) return;

    final viewport = _viewport;
    if (viewport == null) return;

    final layout = IoLayout.of(context);
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

    final scaleBegin =
        _transformationController.value.getMaxScaleOnAxis().roundTo(3);
    final translationBegin =
        _transformationController.value.getTranslation() * scaleBegin;

    final viewportSize = viewport.reduced(layout);
    final beginViewportSize = viewportSize * scaleBegin;

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
    final transformationBegin = Matrix4.translation(translationBegin)
      ..scale(scaleBegin);
    final transformationEnd = Matrix4.translation(translationEnd)
      ..scale(scaleEnd);

    if (transformationBegin != transformationEnd) {
      _transformationAnimation?.removeListener(_onAnimateTransformation);
      _transformationAnimation = Tween(
        begin: transformationBegin,
        end: transformationEnd,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.linear,
        ),
      )..addListener(_onAnimateTransformation);

      animationController.forward(from: 0);
    }
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
            minScale: 0.6,
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
