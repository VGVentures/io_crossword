import 'package:api_client/api_client.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/bottom_bar/view/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart' hide WordSelected;
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/drawer/drawer.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/music/music.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordPage extends StatelessWidget {
  const CrosswordPage({super.key});

  static Route<void> route() {
    return PageRouteBuilder(
      transitionDuration: const Duration(seconds: 3),
      pageBuilder: (_, __, ___) => const CrosswordPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<CrosswordBloc>().add(const BoardLoadingInformationRequested());

    return MultiBlocProvider(
      providers: [
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
          case RandomWordSelectionStatus.initial:
          case RandomWordSelectionStatus.loading:
          // TODO(hugo): Show loading state.
          case RandomWordSelectionStatus.failure:
          // TODO(hugo): Show error modal.
          case RandomWordSelectionStatus.notFound:
            // TODO(hugo): Show popup notifying that the crossword is complete.
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
        body: BlocBuilder<CrosswordBloc, CrosswordState>(
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
                      tag: 'dangle_mascot',
                      child: _Dangle(context.read<PlayerBloc>().state.mascot!),
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
    final layout = IoLayout.of(context);

    return DefaultWordInputController(
      child: Stack(
        children: [
          const Crossword2View(),
          const WordSelectionPage(),
          if (layout == IoLayoutData.large) const BottomBar(),
        ],
      ),
    );
  }
}

class _Dangle extends StatefulWidget {
  const _Dangle(this.mascot);

  final Mascots mascot;

  @override
  State<_Dangle> createState() => _DangleState();
}

class _DangleState extends State<_Dangle> {
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
      width: widget.mascot.teamMascot.dangleSpriteInformation.width,
      height: widget.mascot.teamMascot.dangleSpriteInformation.height,
      child: GestureDetector(
        onTap: () {
          _controller.changeAnimation(
            widget.mascot.teamMascot.dropInAnimation.path,
          );
        },
        child: SpriteAnimationList(
          animationListItems: [
            AnimationListItem(
              path: widget.mascot.teamMascot.dangleAnimation.path,
              spriteInformation:
                  widget.mascot.teamMascot.dangleSpriteInformation,
            ),
            AnimationListItem(
              path: widget.mascot.teamMascot.dropInAnimation.path,
              spriteInformation:
                  widget.mascot.teamMascot.dropInSpriteInformation,
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
