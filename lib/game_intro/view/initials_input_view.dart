import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsInputView extends StatelessWidget {
  const InitialsInputView({super.key});

  static Page<void> page() {
    return const MaterialPage(child: InitialsInputView());
  }

  @override
  Widget build(BuildContext context) {
    return CardScrollableContentWithButton(
      onPressed: () {
        context.read<GameIntroBloc>().add(const InitialsSubmitted());
      },
      buttonLabel: 'Continue',
      child: const Text('Enter your initials!'),
    );
  }
}
