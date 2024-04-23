import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

/// {@template default_transformation_controller}
/// Creates a default [TransformationController] for the child widget.
///
/// See also:
/// *  [CrosswordInteractiveViewer] that consumes the [TransformationController]
/// created by this widget.
/// {@endtemplate}
class DefaultTransformationController extends StatefulWidget {
  const DefaultTransformationController({
    required this.child,
    super.key,
  });

  final Widget child;

  /// Returns the [TransformationController] from the closest
  /// [DefaultTransformationController] ancestor.
  static TransformationController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<TransformationControllerScope>();
    assert(
      scope != null,
      'No $DefaultTransformationController found in context',
    );
    return scope!.transformationController;
  }

  @override
  State<DefaultTransformationController> createState() =>
      _DefaultTransformationControllerState();
}

class _DefaultTransformationControllerState
    extends State<DefaultTransformationController> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TransformationControllerScope(
      transformationController: _transformationController,
      child: widget.child,
    );
  }
}

@visibleForTesting
class TransformationControllerScope extends InheritedWidget {
  @visibleForTesting
  const TransformationControllerScope({
    required this.transformationController,
    required super.child,
    super.key,
  });

  final TransformationController transformationController;

  @override
  bool updateShouldNotify(covariant TransformationControllerScope oldWidget) {
    return transformationController != oldWidget.transformationController;
  }
}
