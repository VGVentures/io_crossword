import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

class WordSelectionPage extends StatelessWidget {
  const WordSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);
    if (selectedWord == null) return const SizedBox.shrink();

    return BlocProvider(
      lazy: false,
      create: (context) => HintBloc(),
      child: const WordSelectionView(),
    );
  }
}
