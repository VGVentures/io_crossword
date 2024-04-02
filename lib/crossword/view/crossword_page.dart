import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/about/about.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/view/word_focused_view.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

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
        boardInfoRepository: context.read<BoardInfoRepository>(),
        crosswordRepository: context.read<CrosswordRepository>(),
        crosswordResource: context.read<CrosswordResource>(),
      )
        ..add(const BoardSectionRequested((0, 0)))
        ..add(const BoardLoadingInfoFetched()),
      child: const CrosswordView(),
    );
  }
}

class CrosswordView extends StatefulWidget {
  @visibleForTesting
  const CrosswordView({super.key});

  @override
  State<CrosswordView> createState() => _CrosswordViewState();
}

class _CrosswordViewState extends State<CrosswordView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<CrosswordBloc>();
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => BlocProvider.value(
          value: bloc,
          child: const GameIntroPage(),
        ),
      );
    });
  }

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
  @visibleForTesting
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
        const Positioned(
          top: 12,
          right: 16,
          child: AboutButton(),
        ),
        const WordFocusedView(),
        _ZoomControls(game: game),
      ],
    );
  }
}

class AboutButton extends StatelessWidget {
  @visibleForTesting
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Icon(Icons.question_mark_rounded),
      onPressed: () {
        AboutView.showModal(context);
      },
    );
  }
}

class _ZoomControls extends StatelessWidget {
  const _ZoomControls({
    required this.game,
  });

  final CrosswordGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 16,
      child: Column(
        children: [
          ElevatedButton(
            key: LoadedBoardView.zoomInKey,
            onPressed: game.zoomIn,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: LoadedBoardView.zoomOutKey,
            onPressed: game.zoomOut,
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}
