import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/bottom_bar/view/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword/music/music.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
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

    return BlocProvider(
      create: (_) => WordSelectionBloc(),
      lazy: false,
      child: const CrosswordView(),
    );
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
      endDrawer: const CrosswordDrawer(),
      appBar: IoAppBar(
        title: const AppBarRankingInformation(),
        crossword: l10n.crossword,
        actions: (context) {
          return const Row(
            children: [
              MuteButton(),
              SizedBox(width: 7),
              EndDrawerButton(),
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

class AppBarRankingInformation extends StatelessWidget {
  @visibleForTesting
  const AppBarRankingInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final rank = context.select((PlayerBloc bloc) => bloc.state.rank);
    final score = context.select((PlayerBloc bloc) => bloc.state.player.score);
    final streak =
        context.select((PlayerBloc bloc) => bloc.state.player.streak);

    return SegmentedButton(
      emptySelectionAllowed: true,
      segments: [
        ButtonSegment(
          value: rank,
          label: Text(rank.toString()),
          icon: const Icon(IoIcons.trophy),
        ),
        ButtonSegment(
          value: score,
          label: Text(score.toDisplayNumber()),
          icon: const Icon(Icons.stars_rounded),
        ),
        ButtonSegment(
          value: streak,
          label: Text(streak.toDisplayNumber()),
          icon: const Icon(Icons.local_fire_department),
        ),
      ],
      selected: const {},
      onSelectionChanged: (_) {
        Navigator.push(context, LeaderboardPage.route());
      },
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
    game = CrosswordGame(
      crosswordBloc: context.read(),
      wordSelectionBloc: context.read(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return Stack(
      children: [
        GameWidget(game: game),
        const WordSelectionView(),
        if (layout == IoLayoutData.large) const BottomBar(),
        _ZoomControls(game: game),
      ],
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
