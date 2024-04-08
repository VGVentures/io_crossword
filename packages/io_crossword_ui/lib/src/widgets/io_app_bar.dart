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
    super.key,
  });

  /// The crossword title used for desktop to show the leading icon.
  final String crossword;

  /// Display actions based on the [IoLayoutData] layout.
  final WidgetBuilder actions;

  /// The title of the app bar.
  final Widget title;

  @override
  Size get preferredSize => const Size(double.infinity, 80);

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    final titleWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
          ),
      child: title,
    );

    return Column(
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
                    Row(
                      children: [
                        const IoLogo(),
                        const SizedBox(width: 5),
                        Text(
                          crossword,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
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
    );
  }
}
