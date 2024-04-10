import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/about/about.dart';
import 'package:io_crossword/bottom_bar/view/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/music/music.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordPage extends StatelessWidget {
  const CrosswordPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CrosswordPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<CrosswordBloc>()
      ..add(const BoardSectionRequested((0, 0)))
      ..add(const BoardLoadingInformationRequested());

    return const CrosswordView();
  }
}

@visibleForTesting
class CrosswordView extends StatelessWidget {
  @visibleForTesting
  const CrosswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        // TODO(Ayad): add SegmentedButtons design
        // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6417693547
        title: const SizedBox(),
        crossword: l10n.crossword,
        actions: (context) {
          return const Row(
            children: [
              MuteButton(),
              SizedBox(width: 7),
              DrawerButton(),
            ],
          );
        },
      ),
      body: BlocBuilder<CrosswordBloc, CrosswordState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          switch (state.status) {
            case CrosswordStatus.initial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case CrosswordStatus.success:
              return const LoadedBoardView();
            case CrosswordStatus.failure:
              return ErrorView(
                title: l10n.errorPromptText,
              );
          }
        },
      ),
    );
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
    final layout = IoLayout.of(context);
    switch (layout) {
      case IoLayoutData.small:
        return _SmallBoardView(game: game);
      case IoLayoutData.large:
        return _LargeBoardView(game: game);
    }
  }
}

class _LargeBoardView extends StatelessWidget {
  const _LargeBoardView({
    required this.game,
  });

  final CrosswordGame game;

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
        const WordFocusedDesktopPage(),
        const BottomBar(),
        _ZoomControls(game: game),
      ],
    );
  }
}

class _SmallBoardView extends StatelessWidget {
  const _SmallBoardView({required this.game});

  final CrosswordGame game;

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
        const WordFocusedMobilePage(),
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
      left: 16,
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
