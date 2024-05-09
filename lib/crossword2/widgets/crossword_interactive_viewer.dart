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
    duration: const Duration(milliseconds: 500),
  );
  Animation<Matrix4>? _transformationAnimation;

  /// The minimum amount of translation allowed.
  final _minTranslation = Vector3.zero();

  /// The maximum amount of translation allowed.
  final _maxTranslation = Vector3.zero();

  void _onAnimateTransformation() {
    _transformationController.value = _transformationAnimation!.value;
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

    final wordSize = selectedWord.word.size(crosswordLayout);
    final wordRect = selectedWord.offset(crosswordLayout) & wordSize;
    final wordCenter = wordRect.center;

    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    var updatedScale = currentScale;
    final translationBegin = _transformationController.value.getTranslation()
      ..scale(currentScale);

    final layout = IoLayout.of(context);

    bool wordFitsInViewport(Size viewport) {
      return viewport.toRect().contains(wordSize.toOffset());
    }

    final viewportSize = viewport.reduced(layout);
    final reducedViewportSize = viewportSize * currentScale;
    final center = Vector3(
      reducedViewportSize.width / 2,
      reducedViewportSize.height / 2,
      0,
    );

    if (currentScale != 1 && wordFitsInViewport(viewportSize)) {
      updatedScale = 1;
    } else if (!wordFitsInViewport(reducedViewportSize)) {
      final widthScale = reducedViewportSize.width < wordSize.width
          ? reducedViewportSize.width / wordSize.width
          : 1;
      final heightScale = reducedViewportSize.height < wordSize.height
          ? reducedViewportSize.height / wordSize.height
          : 1;
      updatedScale = math.min(widthScale, heightScale).toDouble();
    }

    final scaledWordCenter = wordCenter * updatedScale;
    final translationEnd = center -
        Vector3(
          scaledWordCenter.dx,
          scaledWordCenter.dy,
          0,
        );
    translationEnd
      ..x = math.max(
        math.min(translationEnd.x, _minTranslation.x),
        _maxTranslation.x,
      )
      ..y = math.max(
        math.min(translationEnd.y, _minTranslation.y),
        _maxTranslation.y,
      );
    if (translationBegin == translationEnd) return;

    final transformationBegin = Matrix4.translation(translationBegin)
      ..scale(currentScale);
    final transformationEnd = Matrix4.translation(translationEnd)
      ..scale(updatedScale);

    _transformationAnimation?.removeListener(_onAnimateTransformation);
    _transformationAnimation = Tween(
      begin: transformationBegin,
      end: transformationEnd,
    ).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Curves.decelerate,
      ),
    )..addListener(_onAnimateTransformation);

    animationController.forward(from: 0);
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
          height * 0.3,
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
