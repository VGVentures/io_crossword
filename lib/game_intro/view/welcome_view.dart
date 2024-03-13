import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  static Page<void> page() {
    return const MaterialPage(child: WelcomeView());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Welcome!'),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            context.read<GameIntroBloc>().add(const WelcomeCompleted());
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
