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
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 6),
            child: GeminiGradient(
              child: Icon(
                IoIcons.gemini,
                size: 12,
              ),
            ),
          ),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: GeminiGradient(
              // TODO(Ayad): Add IconButton to ask for a hint
              // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6372181970
              child: Icon(Icons.send),
            ),
          ),
        ),
      ),
    );
  }
}

class GeminiHintButton extends StatelessWidget {
  @visibleForTesting
  const GeminiHintButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton.icon(
      style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
        shape: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return const StadiumBorder(
                side: BorderSide(
                  width: 2,
                ),
              );
            }

            return const GradientOutlinedBorder(
              gradient: IoCrosswordColors.geminiGradient,
            );
          },
        ),
      ),
      onPressed: null,
      icon: const GeminiGradient(
        child: Icon(
          IoIcons.gemini,
          size: 12,
        ),
      ),
      label: GeminiGradient(
        child: Text(l10n.hint),
      ),
    );
  }
}
