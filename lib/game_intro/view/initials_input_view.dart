import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

class InitialsInputView extends StatelessWidget {
  const InitialsInputView({super.key});

  static Page<void> page() {
    return const MaterialPage(child: InitialsInputView());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Enter your initials!'),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            context.read<GameIntroBloc>().add(const InitialsSubmitted());
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
