import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class GeminiTextField extends StatelessWidget {
  @visibleForTesting
  const GeminiTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: IoCrosswordTheme.geminiInputDecorationTheme,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: l10n.type,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) =>
                  IoCrosswordColors.geminiGradient.createShader(bounds),
              child: const Icon(IoIcons.gemini),
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) =>
                  IoCrosswordColors.geminiGradient.createShader(bounds),
              // Add IconButton
              child: const Icon(Icons.send),
            ),
          ),
        ),
      ),
    );
  }
}
