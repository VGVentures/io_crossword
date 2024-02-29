import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:io_crossword/game/io_crossword.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const GamePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: GameView()),
    );
  }
}

class GameView extends StatefulWidget {
  const GameView({super.key, this.game});

  final IoCrossword? game;

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  IoCrossword? _game;

  @override
  Widget build(BuildContext context) {
    _game ??= widget.game ?? IoCrossword();
    return Stack(
      children: [
        Positioned.fill(
          child: GameWidget(
            game: _game!,
          ),
        ),
      ],
    );
  }
}
