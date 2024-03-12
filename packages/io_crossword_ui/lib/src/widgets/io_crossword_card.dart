import 'package:flutter/material.dart';

/// {@template io_crossword_card}
/// A panel with slightly rounded corners and an elevation shadow.
///
/// It has a fixed maximum size that adjusts according to the device's
/// orientation.
/// {@endtemplate}
class IoCrosswordCard extends StatelessWidget {
  /// {@macro io_crossword_card}
  const IoCrosswordCard({super.key, this.child});

  /// The widget below this widget in the tree.
  ///
  /// If this widget's size is bigger than the [IoCrosswordCard]'s size,
  /// you should consider scrolling the content.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final constraints = switch (orientation) {
          Orientation.portrait =>
            const BoxConstraints(maxWidth: 358, maxHeight: 540),
          Orientation.landscape =>
            const BoxConstraints(maxWidth: 540, maxHeight: 358),
        };

        return ConstrainedBox(
          constraints: constraints,
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
