import 'package:flutter/material.dart';

/// {@template app_card}
/// An app-styled [Card].
///
/// It has a [_preferredSize] that adapts to the screen orientation.
/// {@endtemplate}
class IoCrosswordCard extends StatelessWidget {
  /// {@macro app_card}
  const IoCrosswordCard({super.key, this.child});

  static const _preferredSize = Size(358, 540);

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final size = switch (orientation) {
          Orientation.portrait => _preferredSize,
          Orientation.landscape =>
            Size(_preferredSize.height, _preferredSize.width),
        };

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(size),
            child: Material(
              type: MaterialType.card,
              borderRadius: BorderRadius.circular(24),
              child: SizedBox.expand(child: child),
            ),
          ),
        );
      },
    );
  }
}
