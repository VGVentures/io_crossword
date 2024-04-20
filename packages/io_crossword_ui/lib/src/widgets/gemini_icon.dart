import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template gemini_icon}
/// A widget that displays the Gemini icon with the Gemini gradient.
/// {@endtemplate}
class GeminiIcon extends StatelessWidget {
  /// {@macro gemini_icon}
  const GeminiIcon({
    super.key,
    this.size = 12,
  });

  /// The size of the icon.
  final double size;

  @override
  Widget build(BuildContext context) {
    return GeminiGradient(
      child: Icon(
        IoIcons.gemini,
        size: size,
      ),
    );
  }
}
