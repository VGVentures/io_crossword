import 'package:crossword_repository/crossword_repository.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';

class CrosswordPage extends StatelessWidget {
  const CrosswordPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CrosswordPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CrosswordBloc(
        context.read<CrosswordRepository>(),
      )..add(const BoardSectionRequested((0, 0))),
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
    } else if (state is CrosswordError) {
      child = const Center(child: Text('Error loading crossword'));
    } else if (state is CrosswordLoaded) {
      child = const LoadedBoardView();
    }

    return Scaffold(body: child);
  }
}

class LoadedBoardView extends StatefulWidget {
  const LoadedBoardView({super.key});

  @visibleForTesting
  static const zoomInKey = Key('game_zoomIn');
  @visibleForTesting
  static const zoomOutKey = Key('game_zoomOut');

  @override
  State<LoadedBoardView> createState() => LoadedBoardViewState();
}

@visibleForTesting
class LoadedBoardViewState extends State<LoadedBoardView> {
  late final CrosswordGame game;

  @override
  void initState() {
    super.initState();

    game = CrosswordGame(context.read());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: game),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            children: [
              ElevatedButton(
                key: LoadedBoardView.zoomInKey,
                onPressed: () {
                  game.zoomIn();
                },
                child: const Icon(Icons.zoom_in),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: LoadedBoardView.zoomOutKey,
                onPressed: () {
                  game.zoomOut();
                },
                child: const Icon(Icons.zoom_out),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
