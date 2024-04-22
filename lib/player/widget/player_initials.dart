import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class PlayerInitials extends StatelessWidget {
  const PlayerInitials({super.key});

  @override
  Widget build(BuildContext context) {
    final initials =
        context.select((PlayerBloc bloc) => bloc.state.player.initials);

    return IoWord(
      initials.toUpperCase(),
      style: Theme.of(context).io.wordTheme.big,
    );
  }
}
