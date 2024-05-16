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
            lazy: false,
            create: (_) => WordSelectionBloc(
              crosswordResource: context.read<CrosswordResource>(),
            ),
          ),
          BlocProvider(
            create: (_) => RandomWordSelectionBloc(
              crosswordRepository: context.read<CrosswordRepository>(),
            ),
          ),
        ],
        child: const CrosswordView(),
      ),
    );
  }
}

class CrosswordView extends StatefulWidget {
  @visibleForTesting
  const CrosswordView({super.key});

  @override
  State<CrosswordView> createState() => _CrosswordViewState();
}

class _CrosswordViewState extends State<CrosswordView>
    with SingleTickerProviderStateMixin {
  final _controller = SpriteListController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool started = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MultiBlocListener(
      listeners: [
        BlocListener<CrosswordBloc, CrosswordState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == CrosswordStatus.success) {
              context.read<RandomWordSelectionBloc>().add(
                    const RandomWordRequested(isInitial: true),
                  );
            }
          },
        ),
        BlocListener<RandomWordSelectionBloc, RandomWordSelectionState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            switch (state.status) {
              case RandomWordSelectionStatus.loading:
              case RandomWordSelectionStatus.notFound:
              case RandomWordSelectionStatus.initial:
              case RandomWordSelectionStatus.failure:
                break;
              case RandomWordSelectionStatus.initialSuccess:
                started = true;
                final position = (
                  state.uncompletedSection!.position.x,
                  state.uncompletedSection!.position.y
                );

                final initialWord = SelectedWord(
                  section: position,
                  word: state.uncompletedSection!.words.firstWhere(
                    (element) => element.solvedTimestamp == null,
                  ),
                );

                context
                    .read<CrosswordBloc>()
                    .add(CrosswordSectionsLoaded(initialWord));
              case RandomWordSelectionStatus.success:
                final position = (
                  state.uncompletedSection!.position.x,
                  state.uncompletedSection!.position.y
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
        ),
      ],
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
        body: BlocListener<CrosswordBloc, CrosswordState>(
          listenWhen: (previous, current) =>
              previous.gameStatus != current.gameStatus,
          listener: (context, state) {
            if (state.gameStatus == GameStatus.resetInProgress) {
              context.read<WordSelectionBloc>().add(const WordUnselected());
            }
          },
          child: Stack(
            children: [
              BlocSelector<CrosswordBloc, CrosswordState, CrosswordStatus>(
                selector: (state) => state.status,
                builder: (context, status) {
                  if (status == CrosswordStatus.failure) {
                    return ErrorView(
                      title: l10n.errorPromptText,
                    );
                  } else if (status == CrosswordStatus.ready) {
                    return FadeInAnimation(
                      onComplete: _controller.playNext,
                      child: const LoadedBoardView(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BlocSelector<CrosswordBloc, CrosswordState, bool>(
                  selector: (state) => state.mascotVisible,
                  builder: (context, visible) {
                    if (visible) {
                      return MascotAnimation(
                        context.read<PlayerBloc>().state.mascot!,
                        _controller,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
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
          BlocSelector<CrosswordBloc, CrosswordState, bool>(
            selector: (state) => state.mascotVisible,
            builder: (context, mascotVisible) {
              return IgnorePointer(
                ignoring: mascotVisible,
                child: const Crossword2View(),
              );
            },
          ),
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

class MascotAnimation extends StatelessWidget {
  @visibleForTesting
  const MascotAnimation(
    this.mascot,
    this.controller, {
    super.key,
  });

  final Mascots mascot;
  final SpriteListController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: platformAwareAsset(
        mobile: Size(
          mascot.teamMascot.dangleSpriteMobileData.width,
          mascot.teamMascot.dangleSpriteMobileData.height,
        ),
        desktop: Size(
          mascot.teamMascot.dangleSpriteDesktopData.width,
          mascot.teamMascot.dangleSpriteDesktopData.height,
        ),
      ),
      child: SpriteAnimationList(
        animationItems: [
          AnimationItem(
            spriteData: platformAwareAsset(
              mobile: mascot.teamMascot.pickUpSpriteMobileData,
              desktop: mascot.teamMascot.pickUpSpriteDesktopData,
            ),
            loop: false,
            onComplete: controller.playNext,
          ),
          AnimationItem(
            spriteData: platformAwareAsset(
              mobile: mascot.teamMascot.dangleSpriteMobileData,
              desktop: mascot.teamMascot.dangleSpriteDesktopData,
            ),
          ),
          AnimationItem(
            spriteData: platformAwareAsset(
              mobile: mascot.teamMascot.dropInSpriteMobileData,
              desktop: mascot.teamMascot.dropInSpriteDesktopData,
            ),
            loop: false,
            onComplete: () =>
                context.read<CrosswordBloc>().add(const MascotDropped()),
          ),
        ],
        controller: controller,
      ),
    );
  }
}

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({
    required this.child,
    this.onComplete,
    super.key,
  });
  final Widget child;
  final VoidCallback? onComplete;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.onComplete != null) {
            widget.onComplete?.call();
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
