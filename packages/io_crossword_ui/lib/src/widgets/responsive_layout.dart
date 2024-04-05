import 'package:flutter/widgets.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// Signature for the individual builders (`small`, `large`).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for
/// various responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    required this.small,
    required this.large,
    super.key,
    this.child,
  });

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder small;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder large;

  /// Optional child widget which will be passed
  /// to the `small` and `large`
  /// builders as a way to share/optimize shared layout.
  final Widget? child;

  /// Checks if the screen is large using [MediaQuery] size.
  ///
  /// If the screen is bigger or equal than [IoCrosswordBreakpoints.medium]
  /// it returns true.
  static bool isLarge(BuildContext context) {
    return !isSmall(context);
  }

  /// Check if the screen is small using [MediaQuery] size.
  ///
  /// If the screen is smaller than [IoCrosswordBreakpoints.medium]
  /// it returns true.
  static bool isSmall(BuildContext context) {
    return MediaQuery.of(context).size.width < IoCrosswordBreakpoints.medium;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < constraints.maxHeight ||
            constraints.maxWidth < IoCrosswordBreakpoints.medium) {
          return small(context, child);
        }
        return large(context, child);
      },
    );
  }
}
