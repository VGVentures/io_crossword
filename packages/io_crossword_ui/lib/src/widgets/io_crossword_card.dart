import 'package:flutter/material.dart';

/// {@template app_card}
/// A panel with slightly rounded corners and an elevation shadow.
///
/// It has a fixed maximum size.
/// {@endtemplate}
class IoCrosswordCard extends StatelessWidget {
  /// {@macro app_card}
  const IoCrosswordCard({super.key, this.child});

  static const _preferredSize = Size(358, 540);

  /// The widget below this widget in the tree.
  ///
  /// If this widget's size is bigger than the [IoCrosswordCard._preferredSize],
  /// you should consider scrolling the content.
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

        return ConstrainedBox(
          constraints: BoxConstraints.loose(size),
          child: Material(
            type: MaterialType.card,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox.expand(child: child),
          ),
        );
      },
    );
  }
}
