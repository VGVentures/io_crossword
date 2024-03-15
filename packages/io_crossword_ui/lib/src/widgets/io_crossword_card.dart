import 'package:flutter/material.dart';

/// {@template io_crossword_card}
/// A panel with slightly rounded corners and an elevation shadow.
///
/// An [IoCrosswordCard] is meant to be the main container of the page. They are
/// not meant to be nested between each other.
///
/// It has a fixed maximum size that adjusts according to the device's
/// layout size. Note that it does not support orientation changes, it assumes
/// the orientation is fixed to portrait.
/// {@endtemplate}
class IoCrosswordCard extends StatelessWidget {
  /// {@macro io_crossword_card}
  const IoCrosswordCard({
    super.key,
    this.maxWidth,
    this.maxHeight,
    this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// If this [child] size is bigger than the [IoCrosswordCard]'s size,
  /// you should consider scrolling the content.
  ///
  /// The [child] will be expanded to fill the [IoCrosswordCard].
  final Widget? child;

  /// The maximum width of the [IoCrosswordCard].
  /// If null, it will use [defaultMaxWidth].
  final double? maxWidth;

  /// The maximum height of the [IoCrosswordCard].
  /// If null, it will use [defaultMaxHeight].
  final double? maxHeight;

  /// The maximum width of the [IoCrosswordCard].
  static const defaultMaxWidth = 358.0;

  /// The maximum height of the [IoCrosswordCard].
  static const defaultMaxHeight = 540.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? defaultMaxWidth,
          maxHeight: maxHeight ?? defaultMaxHeight,
        ),
        child: Material(
          type: MaterialType.card,
          borderRadius: BorderRadius.circular(24),
          child: SizedBox.expand(child: child),
        ),
      ),
    );
  }
}
