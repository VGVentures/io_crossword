import 'package:flutter/material.dart';

/// {@template io_crossword_card}
/// A panel with slightly rounded corners and an elevation shadow.
///
/// It has a fixed maximum size that adjusts according to the device's
/// layout size.
///
/// Does not support orientation changes, it assumes the orientation is fixed
/// to portrait.
/// {@endtemplate}
class IoCrosswordCard extends StatelessWidget {
  /// {@macro io_crossword_card}
  const IoCrosswordCard({super.key, this.child});

  /// The widget below this widget in the tree.
  ///
  /// If this [child] size is bigger than the [IoCrosswordCard]'s size,
  /// you should consider scrolling the content.
  ///
  /// The [child] will be expanded to fill the [IoCrosswordCard].
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 358, maxHeight: 540),
      child: Material(
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(24),
        child: SizedBox.expand(child: child),
      ),
    );
  }
}
