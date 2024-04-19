import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class GeminiTextField extends StatelessWidget {
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
            child: GeminiIcon(),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GeminiGradient(
              child: IconButton(
                onPressed: () {
                  context
                      .read<HintBloc>()
                      .add(const HintRequested('is it red?'));
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
