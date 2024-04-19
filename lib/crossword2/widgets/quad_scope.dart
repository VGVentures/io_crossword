import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' show Quad;
export 'package:vector_math/vector_math_64.dart' show Quad;

/// {@template quad_scope}
/// A widget that provides a [Quad] to its descendants.
///
/// A [Quad] is a a collection of four points that define a quadrilateral.
///
/// In practice, it is used to provided the [Quad], used by
/// [InteractiveViewer.builder] to define its viewport, to the descendants of
/// the [QuadScope].
///
/// See also:
///
/// * [Quad], a collection of four points that define a quadrilateral.
/// * [InteractiveViewerWidgetBuilder] a builder used by
/// [InteractiveViewer.builder] that relies on [Quad] to define its viewport.
/// {@endtemplate}
class QuadScope extends InheritedWidget {
  /// {@macro quad_scope}
  const QuadScope({
    required this.data,
    required super.child,
    super.key,
  });

  /// The [Quad] provided by this widget.
  final Quad data;

  /// Retrieves the [Quad] from the nearest ancestor [QuadScope].
  ///
  /// If there is no [QuadScope] in the given [context], this will throw an
  /// exception.
  static Quad of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<QuadScope>();
    assert(result != null, 'No $QuadScope found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(QuadScope oldWidget) => data != oldWidget.data;
}
