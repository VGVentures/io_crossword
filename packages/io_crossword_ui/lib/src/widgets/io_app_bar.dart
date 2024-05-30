import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_app_bar}
/// AppBar that will be used in the app.
///
/// Uses responsive [IoLayout] to display the app bar for mobile or desktop.
/// {@endtemplate}
class IoAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro io_app_bar}
  const IoAppBar({
    required this.crossword,
    this.actions,
    this.title,
    this.bottom,
    super.key,
  });

  /// The crossword title used for desktop to show the leading icon.
  final String crossword;

  /// Display actions based on the [IoLayoutData] layout.
  final List<Widget>? actions;

  /// The title of the app bar.
  ///
  /// If null will always display [_IoCrosswordLogo].
  final Widget? title;

  /// This widget appears across the bottom of the app bar.
  ///
  ///  * [PreferredSize], which can be used to give an arbitrary widget
  ///  a preferred size.
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size(
        double.infinity,
        80 + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    final titleWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
          ),
      child: title ?? const SizedBox(),
    );

    final actions = this.actions;

    final widget = Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 40,
            child: switch (layout) {
              IoLayoutData.small => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: CustomMultiChildLayout(
                    delegate: AppBarLayout(),
                    children: [
                      LayoutId(
                        id: _AppBarAlignment.start,
                        child: title != null
                            ? titleWidget
                            : _IoCrosswordLogo(crossword: crossword),
                      ),
                      if (actions != null)
                        LayoutId(
                          id: _AppBarAlignment.end,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions,
                          ),
                        ),
                    ],
                  ),
                ),
              IoLayoutData.large => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: CustomMultiChildLayout(
                    delegate: AppBarLayout(),
                    children: [
                      LayoutId(
                        id: _AppBarAlignment.start,
                        child: _IoCrosswordLogo(crossword: crossword),
                      ),
                      LayoutId(
                        id: _AppBarAlignment.center,
                        child: titleWidget,
                      ),
                      if (actions != null)
                        LayoutId(
                          id: _AppBarAlignment.end,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions,
                          ),
                        ),
                    ],
                  ),
                ),
            },
          ),
          const Spacer(),
          const Divider(height: 0),
        ],
      ),
    );

    final bottom = this.bottom;

    if (bottom == null) return widget;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 80),
          child: widget,
        ),
        bottom,
      ],
    );
  }
}

class _IoCrosswordLogo extends StatelessWidget {
  const _IoCrosswordLogo({
    required this.crossword,
  });

  final String crossword;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const IoLogo(),
        const SizedBox(width: 5),
        Text(
          crossword,
          style: Theme.of(context).io.textStyles.h2.bold,
        ),
      ],
    );
  }
}

enum _AppBarAlignment {
  start,
  center,
  end,
}

/// Layout delegate that positions 3 widgets along a horizontal axis in order to
/// keep the middle widget centered and leading and trailing in the left and
/// right side of the screen respectively, independently of which of the 3
/// widgets are present.
@visibleForTesting
class AppBarLayout extends MultiChildLayoutDelegate {
  /// The default spacing around the middle widget.
  static const double kMiddleSpacing = 16;

  @override
  void performLayout(Size size) {
    var leadingWidth = 0.0;
    var trailingWidth = 0.0;

    if (hasChild(_AppBarAlignment.start)) {
      final constraints = BoxConstraints.loose(size);
      final leadingSize = layoutChild(_AppBarAlignment.start, constraints);
      const leadingX = 0.0;
      final leadingY = size.height - leadingSize.height;
      leadingWidth = leadingSize.width;
      positionChild(_AppBarAlignment.start, Offset(leadingX, leadingY));
    }

    if (hasChild(_AppBarAlignment.end)) {
      final constraints = BoxConstraints.loose(size);
      final trailingSize = layoutChild(_AppBarAlignment.end, constraints);
      final trailingX = size.width - trailingSize.width;

      final trailingY = size.height - trailingSize.height;
      trailingWidth = trailingSize.width;
      positionChild(_AppBarAlignment.end, Offset(trailingX, trailingY));
    }

    if (hasChild(_AppBarAlignment.center)) {
      final double maxWidth = math.max(
        size.width - leadingWidth - trailingWidth - kMiddleSpacing * 2.0,
        0,
      );
      final constraints =
          BoxConstraints.loose(size).copyWith(maxWidth: maxWidth);
      final middleSize = layoutChild(_AppBarAlignment.center, constraints);

      final middleX = (size.width - middleSize.width) / 2.0;
      final middleY = size.height - middleSize.height;

      positionChild(_AppBarAlignment.center, Offset(middleX, middleY));
    }
  }

  @override
  bool shouldRelayout(AppBarLayout oldDelegate) => false;
}
