import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';

class CrosswordPage extends StatelessWidget {
  const CrosswordPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (BuildContext context) =>
            CrosswordBloc()..add(const InitialBoardLoadRequested()),
        child: const CrosswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CrosswordView();
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
      child = GameWidget.controlled(
        gameFactory: () => CrosswordGame(
          context.read(),
        ),
      );
    }

    return Scaffold(body: child);
  }
}
