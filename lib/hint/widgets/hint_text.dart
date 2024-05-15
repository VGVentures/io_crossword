import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HintText extends StatelessWidget {
  const HintText({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).io.textStyles;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GeminiIcon(),
        const SizedBox(width: 8),
        GeminiGradient(
          child: Text(
            text,
            style: textTheme.body4,
          ),
        ),
      ],
    );
  }
}
