import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

class MascotSelectionView extends StatelessWidget {
  const MascotSelectionView({super.key});

  static Page<void> page() {
    return const MaterialPage(
      child: MascotSelectionView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Select your mascot!'),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            context.read<GameIntroBloc>().add(const MascotSubmitted());
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }
}
