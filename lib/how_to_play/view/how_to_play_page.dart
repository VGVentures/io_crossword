import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/team_selection/view/view.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  @visibleForTesting
  static const routeName = '/how-to-play';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HowToPlayPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: context.select<PlayerBloc, bool>((bloc) {
        final status = bloc.state.status;
        return status != PlayerStatus.playing && status != PlayerStatus.loading;
      }),
      child: BlocProvider(
        create: (_) => HowToPlayCubit()
          ..loadAssets(
            context.read<PlayerBloc>().state.mascot,
          ),
        child: const HowToPlayView(),
      ),
    );
  }
}

@visibleForTesting
class HowToPlayView extends StatelessWidget {
  @visibleForTesting
  const HowToPlayView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final layout = IoLayout.of(context);

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        actions: const [MuteButton()],
      ),
      body: switch (layout) {
        IoLayoutData.small => const _HowToPlaySmall(),
        IoLayoutData.large => const _HowToPlayLarge(),
      },
    );
  }
}

class _HowToPlaySmall extends StatelessWidget {
  const _HowToPlaySmall();

  @override
  Widget build(BuildContext context) {
    final mascot = context.read<PlayerBloc>().state.mascot;
    final status = context.select((HowToPlayCubit cubit) => cubit.state.status);

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox.fromSize(
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
              child: const _MascotAnimation(),
            ),
          ),
        ),
        if (status == HowToPlayStatus.idle)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              48,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 375),
                      child: SingleChildScrollView(
                        child: HowToPlayPageContent(mascot: mascot),
                      ),
                    ),
                  ),
                  const PlayNowButton(),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HowToPlayLarge extends StatelessWidget {
  const _HowToPlayLarge();

  @override
  Widget build(BuildContext context) {
    final mascot = context.read<PlayerBloc>().state.mascot;
    final status = context.select((HowToPlayCubit cubit) => cubit.state.status);

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox.fromSize(
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
              child: const _MascotAnimation(),
            ),
          ),
        ),
        if (status == HowToPlayStatus.idle)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 539,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      HowToPlayPageContent(mascot: mascot),
                      const SizedBox(height: 40),
                      const PlayNowButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

@visibleForTesting
class HowToPlayPageContent extends StatelessWidget {
  @visibleForTesting
  const HowToPlayPageContent({required this.mascot, super.key});

  final Mascot mascot;

  @override
  Widget build(BuildContext context) {
    return HowToPlayContent(
      mascot: mascot,
      onDonePressed: () {
        context.read<AudioController>().playSfx(Assets.music.startButton1);
        context
            .read<PlayerBloc>()
            .add(PlayerCreateScoreRequested(context.read<User>().id));
        context.read<HowToPlayCubit>().updateStatus(HowToPlayStatus.pickingUp);
      },
    );
  }
}

class _MascotAnimation extends StatefulWidget {
  const _MascotAnimation();

  @override
  State<_MascotAnimation> createState() => _MascotAnimationState();
}

class _MascotAnimationState extends State<_MascotAnimation> {
  final SpriteListController _controller = SpriteListController();

  @override
  Widget build(BuildContext context) {
    final mascot = context.read<PlayerBloc>().state.mascot;

    return BlocConsumer<HowToPlayCubit, HowToPlayState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HowToPlayStatus.pickingUp) {
          _controller.update();
        }
      },
      builder: (context, state) {
        return state.assetsStatus == AssetsLoadingStatus.inProgress
            ? const SizedBox.shrink()
            : SpriteAnimationList(
                animationItems: [
                  AnimationItem(
                    spriteData: platformAwareAsset(
                      mobile: mascot.teamMascot.lookUpSpriteMobileData,
                      desktop: mascot.teamMascot.lookUpSpriteDesktopData,
                    ),
                    onComplete: () {
                      Navigator.of(context).pushAndRemoveUntil<void>(
                        CrosswordPage.route(),
                        (route) => route.isFirst,
                      );
                    },
                  ),
                ],
                controller: _controller,
              );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
