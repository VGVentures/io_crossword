import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/board_status/board_status.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/drawer/drawer.dart';
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
          BlocProvider(
            create: (_) => BoardStatusBloc(
              boardInfoRepository: context.read<BoardInfoRepository>(),
            )..add(const BoardStatusRequested()),
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
        BlocListener<BoardStatusBloc, BoardStatusState>(
          listener: (context, state) {
            if (state is BoardStatusResetInProgress) {
              context.read<CrosswordBloc>().add(const BoardStatusPaused());
              context.read<WordSelectionBloc>().add(const WordUnselected());
            }
          },
        ),
      ],
      child: Scaffold(
        endDrawer: const CrosswordDrawer(),
        resizeToAvoidBottomInset: false,
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
        body: Stack(
          children: [
            _CrosswordBody(controller: _controller),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocSelector<CrosswordBloc, CrosswordState, bool>(
                selector: (state) => state.mascotVisible,
                builder: (context, visible) {
                  if (visible) {
                    return MascotAnimation(
                      context.read<PlayerBloc>().state.mascot,
                      _controller,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            BlocSelector<CrosswordBloc, CrosswordState, BoardStatus>(
              selector: (state) => state.boardStatus,
              builder: (context, boardStatus) {
                if (boardStatus == BoardStatus.resetInProgress) {
                  return BoardResetView(
                    onResume: () {
                      context
                          .read<CrosswordBloc>()
                          .add(const BoardStatusResumed());

                      context.read<RandomWordSelectionBloc>().add(
                            const RandomWordRequested(isInitial: true),
                          );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// {@template _crossword_body}
/// The main body of the crossword page.
///
/// When the crossword is ready is displays the [CrosswordPlayingView], so that
/// the user can play the crossword. When the mascot is being dropped in, it
/// slowly fades in the crossword board.
///
/// If for some reason the crossword fails to load or the user failed to be
/// created, an [ErrorView] is displayed.
/// {@endtemplate}
class _CrosswordBody extends StatelessWidget {
  /// {@macro _crossword_body}
  const _CrosswordBody({
    required SpriteListController controller,
  }) : _spriteListController = controller;

  final SpriteListController _spriteListController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final crosswordStatus = context.select<CrosswordBloc, CrosswordStatus>(
      (bloc) => bloc.state.status,
    );
    final playerStatus = context.select<PlayerBloc, PlayerStatus>(
      (bloc) => bloc.state.status,
    );

    return switch ((crosswordStatus, playerStatus)) {
      (CrosswordStatus.failure, _) ||
      (_, PlayerStatus.failure) =>
        ErrorView(title: l10n.errorPromptText),
      (CrosswordStatus.ready, PlayerStatus.playing) => FadeInAnimation(
          onComplete: _spriteListController.playNext,
          child: const CrosswordPlayingView(),
        ),
      _ => const SizedBox.shrink(),
    };
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
