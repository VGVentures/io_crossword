import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/bottom_bar/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/random_word_selection/random_word_selection.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordPage extends StatelessWidget {
  const CrosswordPage({super.key});

  @visibleForTesting
  static const String routeName = '/crossword';

  static Route<void> route() {
    return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 3),
      settings: const RouteSettings(name: routeName),
      pageBuilder: (_, __, ___) => const CrosswordPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CrosswordBloc(
              crosswordRepository: context.read<CrosswordRepository>(),
              boardInfoRepository: context.read<BoardInfoRepository>(),
            )..add(const BoardLoadingInformationRequested()),
          ),
          BlocProvider(
            create: (_) => WordSelectionBloc(
              crosswordResource: context.read<CrosswordResource>(),
            ),
          ),
          BlocProvider(
            create: (_) => RandomWordSelectionBloc(
              crosswordRepository: context.read<CrosswordRepository>(),
            )..add(const RandomWordRequested()),
          ),
        ],
        child: const CrosswordView(),
      ),
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
    return BlocListener<RandomWordSelectionBloc, RandomWordSelectionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case RandomWordSelectionStatus.loading:
            RandomWordLoadingDialog.openDialog(context);
          case RandomWordSelectionStatus.notFound:
          case RandomWordSelectionStatus.initial:
          case RandomWordSelectionStatus.failure:
            break;
          case RandomWordSelectionStatus.success:
            final position = (
              state.uncompletedSection!.position.x,
              state.uncompletedSection!.position.y
            );
            context.read<CrosswordBloc>().add(
                  BoardSectionRequested(position),
                );
            context.read<WordSelectionBloc>().add(
                  WordSelected(
                    selectedWord: SelectedWord(
                      section: position,
                      word: state.uncompletedSection!.words.firstWhere(
                        (element) => element.solvedTimestamp == null,
                      ),
                    ),
                  ),
                );
        }
      },
      child: Scaffold(
        endDrawer: const CrosswordDrawer(),
        appBar: IoAppBar(
          title: const PlayerRankingInformation(),
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
        body: BlocConsumer<CrosswordBloc, CrosswordState>(
          listenWhen: (previous, current) =>
              previous.gameStatus != current.gameStatus,
          listener: (context, state) {
            if (state.gameStatus == GameStatus.resetInProgress) {
              context.read<WordSelectionBloc>().add(const WordUnselected());
            }
          },
          buildWhen: (previous, current) =>
              previous.status != current.status ||
              previous.mascotVisible != current.mascotVisible,
          builder: (context, state) {
            return Stack(
              children: [
                switch (state.status) {
                  CrosswordStatus.initial => const SizedBox.shrink(),
                  CrosswordStatus.success => const LoadedBoardView(),
                  CrosswordStatus.failure => ErrorView(
                      title: l10n.errorPromptText,
                    ),
                },
                if (state.mascotVisible)
                  Align(
                    child: Hero(
                      tag: HowToPlayPage.dangleMascotHeroTag,
                      child: MascotAnimation(
                        context.read<PlayerBloc>().state.mascot!,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@visibleForTesting
class LoadedBoardView extends StatelessWidget {
  @visibleForTesting
  const LoadedBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final boardStatus = context.select(
      (CrosswordBloc bloc) => bloc.state.boardStatus,
    );

    return DefaultWordInputController(
      child: Stack(
        children: [
          const Crossword2View(),
          const WordSelectionPage(),
          if (boardStatus != BoardStatus.resetInProgress)
            const BottomBar()
          else
            const ColoredBox(
              color: Color(0x88000000),
              child: Center(
                child: ResetDialogContent(),
              ),
            ),
        ],
      ),
    );
  }
}

class ResetDialogContent extends StatelessWidget {
  @visibleForTesting
  const ResetDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IoPhysicalModel(
      child: Card(
        child: SizedBox(
          width: 340,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Text(
                  l10n.resetDialogTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.resetDialogSubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const _BottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final gameStatus = context.select(
      (CrosswordBloc bloc) => bloc.state.gameStatus,
    );

    final resetInProgress = gameStatus == GameStatus.resetInProgress;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => EndGameCheck.openDialog(context),
            child: Text(l10n.exitButtonLabel),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: resetInProgress
                ? null
                : () => context
                    .read<CrosswordBloc>()
                    .add(const BoardStatusResumed()),
            child: Text(l10n.keepPlayingButtonLabel),
          ),
        ),
      ],
    );
  }
}

class MascotAnimation extends StatefulWidget {
  @visibleForTesting
  const MascotAnimation(this.mascot, {super.key});

  final Mascots mascot;

  @override
  State<MascotAnimation> createState() => _MascotAnimationState();
}

class _MascotAnimationState extends State<MascotAnimation> {
  final _controller = SpriteListController();

  @override
  void initState() {
    super.initState();

    _controller.changeAnimation(widget.mascot.teamMascot.dangleAnimation.path);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.mascot.teamMascot.dangleSpriteData.width,
      height: widget.mascot.teamMascot.dangleSpriteData.height,
      child: GestureDetector(
        onTap: () {
          _controller.changeAnimation(
            widget.mascot.teamMascot.dropInAnimation.path,
          );
        },
        child: SpriteAnimationList(
          animationItems: [
            AnimationItem(
              spriteData: widget.mascot.teamMascot.dangleSpriteData,
            ),
            AnimationItem(
              spriteData: widget.mascot.teamMascot.dropInSpriteData,
              loop: false,
              onComplete: () =>
                  context.read<CrosswordBloc>().add(const MascotDropped()),
            ),
          ],
          controller: _controller,
        ),
      ),
    );
  }
}
