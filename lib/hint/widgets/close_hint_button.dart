import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CloseHintButton extends StatelessWidget {
  const CloseHintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(18),
      ),
      onPressed: () {
        context.read<HintBloc>().add(const HintModeExited());
      },
      icon: const GeminiGradient(
        child: Icon(Icons.close),
      ),
    );
  }
}
