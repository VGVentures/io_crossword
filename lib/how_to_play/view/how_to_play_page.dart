import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  static const String dangleMascotHeroTag = 'dangle_mascot_tag';

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
        create: (_) => HowToPlayCubit(),
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
        actions: (context) => const MuteButton(),
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
    final mascot = context.select((PlayerBloc bloc) => bloc.state.mascot);
    final status = context.select((HowToPlayCubit cubit) => cubit.state.status);

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: mascot!.teamMascot.dangleSpriteData.width,
            height: mascot.teamMascot.dangleSpriteData.height,
            child: const Hero(
              tag: HowToPlayPage.dangleMascotHeroTag,
              child: _MascotAnimation(),
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
                        child: HowToPlayContent(
                          mascot: mascot,
                          onDonePressed: () {
                            context
                                .read<HowToPlayCubit>()
                                .updateStatus(HowToPlayStatus.pickingUp);
                            context
                                .read<AudioController>()
                                .playSfx(Assets.music.startButton1);
                          },
                        ),
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
    final status = context.select((HowToPlayCubit cubit) => cubit.state.status);
    final mascot = context.select((PlayerBloc bloc) => bloc.state.mascot);

    return Stack(
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: mascot!.teamMascot.dangleSpriteData.width,
                  height: mascot.teamMascot.dangleSpriteData.height,
                  child: const Hero(
                    tag: HowToPlayPage.dangleMascotHeroTag,
                    child: _MascotAnimation(),
                  ),
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
                          HowToPlayContent(
                            mascot: mascot,
                            onDonePressed: () {
                              context
                                  .read<HowToPlayCubit>()
                                  .updateStatus(HowToPlayStatus.pickingUp);
                              context
                                  .read<AudioController>()
                                  .playSfx(Assets.music.startButton1);
                            },
                          ),
                          const SizedBox(height: 40),
                          const PlayNowButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _MascotAnimation extends StatefulWidget {
  const _MascotAnimation();

  @override
  State<_MascotAnimation> createState() => _MascotAnimationState();
}

class _MascotAnimationState extends State<_MascotAnimation> {
  late SpriteListController controller = SpriteListController();

  @override
  Widget build(BuildContext context) {
    final mascot = context.read<PlayerBloc>().state.mascot;

    return BlocListener<HowToPlayCubit, HowToPlayState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == HowToPlayStatus.pickingUp) {
          controller.changeAnimation(mascot.teamMascot.pickUpAnimation.path);
        }

        if (state.status == HowToPlayStatus.complete) {
          Navigator.of(context).pushAndRemoveUntil<void>(
            CrosswordPage.route(),
            (route) => route.isFirst,
          );
        }
      },
      child: SpriteAnimationList(
        animationItems: [
          AnimationItem(
            spriteData: mascot!.teamMascot.lookUpSpriteData,
          ),
          AnimationItem(
            spriteData: mascot.teamMascot.pickUpSpriteData,
            loop: false,
            onComplete: () {
              context
                  .read<HowToPlayCubit>()
                  .updateStatus(HowToPlayStatus.complete);
            },
          ),
          AnimationItem(
            spriteData: mascot.teamMascot.dangleSpriteData,
          ),
        ],
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
