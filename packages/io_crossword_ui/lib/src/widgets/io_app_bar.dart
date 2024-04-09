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
    required this.actions,
    required this.title,
    this.alwaysShowLogo = false,
    this.bottom,
    super.key,
  });

  /// Display the logo always in the app bar.
  ///
  /// If this is false we display only in web.
  final bool alwaysShowLogo;

  /// The crossword title used for desktop to show the leading icon.
  final String crossword;

  /// Display actions based on the [IoLayoutData] layout.
  final WidgetBuilder actions;

  /// The title of the app bar.
  final Widget title;

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
      child: title,
    );

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
                      if (alwaysShowLogo)
                        _IoLogo(
                          crossword: crossword,
                        ),
                      titleWidget,
                      actions(context),
                    ],
                  ),
                ),
              IoLayoutData.large => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _IoLogo(
                        crossword: crossword,
                      ),
                      titleWidget,
                      actions(context),
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

class _IoLogo extends StatelessWidget {
  const _IoLogo({
    required this.crossword,
  });

  final String crossword;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IoLogo(),
        const SizedBox(width: 5),
        Text(
          crossword,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
