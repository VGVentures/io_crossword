import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template card_scrollable_content_with_button}
/// A layout to use inside an [IoCrosswordCard] with a scrollable content area
/// and a button at the bottom.
///
/// The content area is scrollable if its size is bigger than the card's size.
/// {@endtemplate}
class CardScrollableContentWithButton extends StatelessWidget {
  /// {@macro card_scrollable_content_with_button}
  const CardScrollableContentWithButton({
    required this.child,
    required this.buttonLabel,
    required this.onPressed,
    this.padding = const EdgeInsets.all(24),
    super.key,
  });

  /// The widget for the content area above the button.
  final Widget child;

  /// The text to display in the button.
  final String buttonLabel;

  /// The callback called when the button is tapped.
  final VoidCallback onPressed;

  /// The padding around the content area and the button.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final contentMaxHeight = IoCrosswordCard.defaultMaxHeight -
        padding.vertical -
        PrimaryButton.defaultHeight;

    return Padding(
      padding: padding,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: contentMaxHeight),
                child: child,
              ),
            ),
          ),
          PrimaryButton(
            onPressed: onPressed,
            label: buttonLabel,
          ),
        ],
      ),
    );
  }
}
