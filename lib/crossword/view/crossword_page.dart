import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';

class CrosswordPage extends StatelessWidget {
  const CrosswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CrosswordBloc()..add(const InitialBoardLoadRequested()),
      child: const CrosswordView(),
    );
  }
}

class CrosswordView extends StatelessWidget {
  const CrosswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CrosswordBloc>();
    final state = bloc.state;

    late final Widget child;
    if (state is CrosswordInitial) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CrosswordLoading) {
      child = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is CrosswordError) {
      child = const Center(child: Text('Error loading crossword'));
    } else if (state is CrosswordLoaded) {
      child = const GameWidget.controlled(
        gameFactory: CrosswordGame.new,
      );
    }

    return Scaffold(body: child);
  }
}
