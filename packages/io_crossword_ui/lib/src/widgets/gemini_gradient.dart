import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_crossword_card}
/// A widget that will give the Gemini gradient to [child].
///
/// {@endtemplate}
class GeminiGradient extends StatelessWidget {
  /// {@macro io_crossword_card}
  const GeminiGradient({
    required this.child,
    super.key,
  });

  /// The widget below this widget in the tree.
  ///
  /// The [child] will be displayed with [ShaderMask] using
  /// [IoCrosswordColors.geminiGradient].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) =>
          IoCrosswordColors.geminiGradient.createShader(bounds),
      child: child,
    );
  }
}
