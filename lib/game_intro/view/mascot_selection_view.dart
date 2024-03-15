import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class MascotSelectionView extends StatelessWidget {
  const MascotSelectionView({super.key});

  static Page<void> page() {
    return const MaterialPage(
      child: MascotSelectionView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardScrollableContentWithButton(
      onPressed: () {
        context.read<GameIntroBloc>().add(const MascotSubmitted());
      },
      buttonLabel: 'Continue',
      child: const Text('Select your mascot!'),
    );
  }
}
