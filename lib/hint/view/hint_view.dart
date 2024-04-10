import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_focused/bloc/word_focused_bloc.dart';
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
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GeminiGradient(
              child: IconButton(
                onPressed: () {
                  // TODO(Any): send question to gemini
                  context.read<WordFocusedBloc>().add(
                        const SolvingFocusSwitched(),
                      );
                },
                icon: const Icon(Icons.send),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GeminiHintButton extends StatelessWidget {
  const GeminiHintButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton.icon(
      style: IoCrosswordTheme.geminiOutlinedButtonThemeData.style,
      onPressed: () => context.read<WordFocusedBloc>().add(
            const SolvingFocusSwitched(),
          ),
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
