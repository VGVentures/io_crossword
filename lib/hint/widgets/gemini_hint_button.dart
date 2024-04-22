import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class GeminiHintButton extends StatelessWidget {
  const GeminiHintButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final isOutOfHints =
        context.select((HintBloc bloc) => bloc.state.hintsLeft <= 0);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 128),
      child: OutlinedButton.icon(
        style: IoCrosswordTheme.geminiOutlinedButtonThemeData.style,
        onPressed: isOutOfHints
            ? null
            : () => context.read<HintBloc>().add(const HintModeEntered()),
        icon: const GeminiIcon(),
        label: GeminiGradient(
          child: Text(l10n.hint),
        ),
      ),
    );
  }
}
