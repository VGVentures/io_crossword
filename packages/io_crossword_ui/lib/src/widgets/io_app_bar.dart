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
    required this.logo,
    this.actions,
    this.title,
    this.bottom,
    super.key,
  });

  /// The crossword title used for desktop to show the leading icon.
  final Widget logo;

  /// Display actions based on the [IoLayoutData] layout.
  final WidgetBuilder? actions;

  /// The title of the app bar.
  ///
  /// If null will always display the [logo].
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (title == null) logo else titleWidget,
                      if (actions != null) actions(context),
                    ],
                  ),
                ),
              IoLayoutData.large => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Stack(
                    children: [
                      Center(child: titleWidget),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          logo,
                          if (actions != null) actions(context),
                        ],
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
