import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HintText extends StatelessWidget {
  const HintText({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    final isShowHintTextField =
        context.select((HintBloc bloc) => bloc.state.isShowHintTextField);
    final text =
        isShowHintTextField ? l10n.askYesOrNoQuestion : l10n.askGeminiHint;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const GeminiIcon(),
        const SizedBox(width: 8),
        GeminiGradient(
          child: Text(
            text,
            style: textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
