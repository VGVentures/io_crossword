import 'package:flutter/widgets.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_layout}
/// Describes the layout of the current window.
/// {@endtemplate}
enum IoLayoutData {
  /// A small layout.
  ///
  /// Typically used for mobile devices.
  small,

  /// A large layout.
  ///
  /// Typically used for tablets and desktops.
  large;

  /// Derive the layout from the given [windowSize].
  static IoLayoutData _derive(Size windowSize) {
    return windowSize.width < windowSize.height ||
            windowSize.width < IoCrosswordBreakpoints.medium
        ? IoLayoutData.small
        : IoLayoutData.large;
  }
}

/// {@template io_layout}
/// Calculates and provides [IoLayoutData] to its descendants.
///
/// See also:
///
/// * [IoLayout.of], a static method which retrieves the closest [IoLayoutData].
/// * [IoLayoutData], an enum which describes the layout of the current window.
/// {@endtemplate}
class IoLayout extends StatelessWidget {
  /// {@macro io_layout}
  const IoLayout({
    required this.child,
    this.data,
    super.key,
  });

  /// The layout to provide to the child.
  ///
  /// If `null` it is derived from the current layout of the window. Otherwise,
  /// it will be fixed to the provided value.
  final IoLayoutData? data;

  /// The child widget which will have access to the current [IoLayoutData].
  final Widget child;

  /// Retrieves the closest [_IoLayoutScope] from the given [context].
  static IoLayoutData of(BuildContext context) {
    final layout = context.dependOnInheritedWidgetOfExactType<_IoLayoutScope>();
    assert(layout != null, 'No IoLayout found in context');
    return layout!.layout;
  }

  @override
  Widget build(BuildContext context) {
    return _IoLayoutScope(
      layout: data ?? IoLayoutData._derive(MediaQuery.sizeOf(context)),
      child: child,
    );
  }
}

/// {@template io_layout_scope}
/// A widget which provides the current [IoLayoutData] to its descendants.
/// {@endtemplate}
class _IoLayoutScope extends InheritedWidget {
  /// {@macro io_layout_scope}
  const _IoLayoutScope({
    required super.child,
    required this.layout,
  });

  /// {@macro io_layout_data}
  final IoLayoutData layout;

  @override
  bool updateShouldNotify(covariant _IoLayoutScope oldWidget) {
    return layout != oldWidget.layout;
  }
}
