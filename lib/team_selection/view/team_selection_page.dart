import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' hide Axis;
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class TeamSelectionPage extends StatelessWidget {
  const TeamSelectionPage({super.key});

  static Page<void> page() {
    return const MaterialPage(
      child: TeamSelectionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamSelectionCubit(),
      child: const TeamSelectionView(),
    );
  }
}

@visibleForTesting
class TeamSelectionView extends StatelessWidget {
  @visibleForTesting
  const TeamSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final mascots = [
      Mascot(
        mascot: Mascots.dash,
        name: 'Dash',
        image: Assets.images.dash.path,
        gradientColors: const [
          Color(0xFF00A947),
          Color(0xFF1F85FA),
          Color(0xFF00A947),
        ],
      ),
      Mascot(
        mascot: Mascots.sparky,
        name: 'Sparky',
        image: Assets.images.sparky.path,
        gradientColors: const [
          Color(0xFFFFC700),
          Color(0xFFFD2B25),
          Color(0xFFFFC700),
        ],
      ),
      Mascot(
        mascot: Mascots.android,
        name: 'Android',
        image: Assets.images.android.path,
        gradientColors: const [
          Color(0xFFFFC700),
          Color(0xFF00A947),
          Color(0xFFFFC700),
        ],
      ),
      Mascot(
        mascot: Mascots.dino,
        name: 'Dino',
        image: Assets.images.dino.path,
        gradientColors: const [
          Color(0xFF4383F2),
          Color(0xFFFD2B25),
          Color(0xFF4383F2),
        ],
      ),
    ];

    final layout = IoLayout.of(context);

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
      ),
      body: switch (layout) {
        IoLayoutData.small => _TeamSelectorSmall(mascots),
        IoLayoutData.large => _TeamSelectorLarge(mascots),
      },
    );
  }
}

class _TeamSelectorLarge extends StatelessWidget {
  const _TeamSelectorLarge(this.mascots);

  final List<Mascot> mascots;

  static const tileWidth = 208.0;
  static const tileHeight = 119.0;

  static const platformTileHeight = 131.0;

  static const mascotWidth = 100.0;
  static const mascotHeight = 200.0;

  // The top position of the platform tile for Dash and Dino.
  static const bottomPlatformTileTopPosition =
      platformTileHeight * 2 - (platformTileHeight - tileHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocBuilder<TeamSelectionCubit, int>(
      builder: (context, state) {
        return Stack(
          children: [
            Positioned.fill(
              child: Assets.images.tile.image(
                repeat: ImageRepeat.repeat,
              ),
            ),
            Align(
              child: SizedBox(
                width: tileWidth * 5,
                height:
                    platformTileHeight * 3 + (platformTileHeight - tileHeight),
                child: Stack(
                  children: [
                    Positioned(
                      top: bottomPlatformTileTopPosition,
                      left: 0,
                      child: state == Mascots.dash.index
                          ? SizedBox(
                              width: tileWidth,
                              height: platformTileHeight,
                              child: SpriteAnimationWidget.asset(
                                images: Images(prefix: ''),
                                anchor: Anchor.bottomCenter,
                                path: Assets.anim.dashPlatform.path,
                                data: SpriteAnimationData.sequenced(
                                  amount: 60,
                                  stepTime: 0.042,
                                  textureSize: Vector2(958, 605),
                                  amountPerRow: 6,
                                ),
                              ),
                            )
                          : Assets.images.platform.image(),
                    ),
                    Positioned(
                      top: platformTileHeight,
                      left: tileWidth,
                      child: state == Mascots.sparky.index
                          ? GradientAnimation(
                              mascot: mascots[state],
                              width: tileWidth,
                              height: platformTileHeight,
                            )
                          : Assets.images.platform.image(),
                    ),
                    Positioned(
                      top: platformTileHeight,
                      left: tileWidth * 3,
                      child: state == Mascots.android.index
                          ? GradientAnimation(
                              mascot: mascots[state],
                              width: tileWidth,
                              height: platformTileHeight,
                            )
                          : Assets.images.platform.image(),
                    ),
                    Positioned(
                      top: bottomPlatformTileTopPosition,
                      left: tileWidth * 4,
                      child: state == Mascots.dino.index
                          ? GradientAnimation(
                              mascot: mascots[state],
                              width: tileWidth,
                              height: platformTileHeight,
                            )
                          : Assets.images.platform.image(),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              child: SizedBox(
                // Width:
                // 5 tiles wide (208 * 5)
                // Center moscots by subtacting a half a tile.
                width: (tileWidth * 5) - (tileWidth * .5),
                height: tileHeight * 3,
                child: Stack(
                  children: [
                    ...mascots.map(
                      (mascot) => Positioned(
                        left: mascots.indexOf(mascot) == 2 ||
                                mascots.indexOf(mascot) == 3
                            ? ((mascots.indexOf(mascot).toDouble()) *
                                    tileWidth) +
                                tileWidth
                            : (mascots.indexOf(mascot).toDouble()) * tileWidth,
                        bottom: mascots.indexOf(mascot) == 1 ||
                                mascots.indexOf(mascot) == 2
                            ? tileHeight + (tileHeight / 2)
                            : 0 + (tileHeight / 2),
                        child: mascot.mascot == Mascots.dash
                            ? SizedBox(
                                width: mascotWidth,
                                height: mascotHeight,
                                child: SpriteAnimationWidget.asset(
                                  images: Images(prefix: ''),
                                  anchor: Anchor.bottomCenter,
                                  path: Assets.anim.dashIdle.path,
                                  data: SpriteAnimationData.sequenced(
                                    amount: 70,
                                    stepTime: 0.042,
                                    textureSize: Vector2(300, 336),
                                    amountPerRow: 10,
                                  ),
                                ),
                              )
                            : mascot.mascot == Mascots.android
                                ? SizedBox(
                                    width: mascotWidth,
                                    height: mascotHeight,
                                    child: SpriteAnimationWidget.asset(
                                      images: Images(prefix: ''),
                                      anchor: Anchor.bottomCenter,
                                      path: Assets.anim.androidIdle.path,
                                      data: SpriteAnimationData.sequenced(
                                        amount: 28,
                                        stepTime: 0.042,
                                        textureSize: Vector2(250, 360),
                                        amountPerRow: 7,
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    mascot.image,
                                    alignment: Alignment.bottomCenter,
                                    width: mascotWidth,
                                    height: mascotHeight,
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                l10n.chooseYourTeam,
                style: theme.textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(45),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TeamSelector(
                      mascots: mascots,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TeamSelectorSmall extends StatefulWidget {
  const _TeamSelectorSmall(this.mascots);

  final List<Mascot> mascots;

  @override
  State<_TeamSelectorSmall> createState() => _TeamSelectorSmallState();
}

class _TeamSelectorSmallState extends State<_TeamSelectorSmall>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  late ScrollController _scrollController;

  static const tileWidth = 366.0;
  static const tileHeight = 209.0;

  static const platformTileHeight = 231.0;

  @override
  void initState() {
    super.initState();

    // _tabController = TabController(
    //   length: widget.mascots.length,
    //   vsync: this,
    //   initialIndex: context.read<TeamSelectionCubit>().state,
    // );

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final halfScreenWidth = MediaQuery.of(context).size.width / 2;
    // -100;

    return BlocConsumer<TeamSelectionCubit, int>(
      listener: (context, state) {
        // _tabController.animateTo(
        //   state,
        //   duration: const Duration(milliseconds: 400),
        //   curve: Curves.easeInOut,
        // );

        _scrollController.animateTo(
          state.toDouble() * (tileWidth * 2),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      builder: (context, state) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                // The width of the background board is 15x12 tiles. This is
                // a little bigger than we need to make sure the grid shows
                // when the mascots are the end are selected and when the
                // user is zoomed out.
                width: tileWidth * 15,
                height: tileHeight * 12,
                child: Stack(
                  children: [
                    // If the width of the window changes, we need to
                    // caclulate the edge of the background to keep the
                    // mascots in the center.
                    Positioned.fill(
                      left: ((MediaQuery.of(context).size.width) * 1 +
                              (tileWidth * .001)) -
                          (tileWidth * 8),
                      // Move the board a half a tile up to align the
                      // mascots a little higher.
                      top: -(tileHeight / 2),
                      child: Image.asset(
                        Assets.images.tileLarge.path,
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                    Positioned.fill(
                      left: halfScreenWidth - tileWidth / 2,
                      bottom: -((tileHeight / 2) -
                          (platformTileHeight - tileHeight)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          // 4 platform tiles with a tile in between.
                          width: tileWidth * 7,
                          child: Stack(
                            children: [
                              Positioned(
                                child: state == Mascots.dash.index
                                    // ? GradientAnimation(
                                    //     mascot: widget.mascots[state],
                                    //     width: tileWidth,
                                    //     height: platformTileHeight,
                                    //   )
                                    ? SizedBox(
                                        width: tileWidth,
                                        height: platformTileHeight,
                                        child: SpriteAnimationWidget.asset(
                                          images: Images(prefix: ''),
                                          anchor: Anchor.bottomCenter,
                                          path: Assets.anim.dashPlatform.path,
                                          data: SpriteAnimationData.sequenced(
                                            amount: 60,
                                            stepTime: 0.042,
                                            textureSize: Vector2(958, 605),
                                            amountPerRow: 6,
                                          ),
                                        ),
                                      )
                                    : Assets.images.platformLarge.image(
                                        width: tileWidth,
                                        height: platformTileHeight,
                                      ),
                              ),
                              Positioned(
                                left: tileWidth * 2,
                                child: state == Mascots.sparky.index
                                    ? GradientAnimation(
                                        mascot: widget.mascots[state],
                                        width: tileWidth,
                                        height: platformTileHeight,
                                      )
                                    : Assets.images.platformLarge.image(
                                        width: tileWidth,
                                        height: platformTileHeight,
                                      ),
                              ),
                              Positioned(
                                left: tileWidth * 4,
                                child: state == Mascots.android.index
                                    ? GradientAnimation(
                                        mascot: widget.mascots[state],
                                        width: tileWidth,
                                        height: platformTileHeight,
                                      )
                                    : Assets.images.platformLarge.image(
                                        width: tileWidth,
                                        height: platformTileHeight,
                                      ),
                              ),
                              Positioned(
                                left: tileWidth * 6,
                                child: state == Mascots.dino.index
                                    ? GradientAnimation(
                                        mascot: widget.mascots[state],
                                        width: tileWidth,
                                        height: platformTileHeight,
                                      )
                                    : Assets.images.platformLarge.image(
                                        width: tileWidth,
                                        height: platformTileHeight,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: halfScreenWidth - 100,
                      top: -tileHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: tileWidth * 7,
                          height: 400,
                          child: Stack(
                            children: [
                              ...widget.mascots.map(
                                (mascot) => Positioned(
                                  left: (2 *
                                          widget.mascots
                                              .indexOf(mascot)
                                              .toDouble()) *
                                      tileWidth,
                                  child: mascot.mascot == Mascots.dash
                                      ? SizedBox(
                                          width: 200,
                                          height: 400,
                                          child: SpriteAnimationWidget.asset(
                                            images: Images(prefix: ''),
                                            anchor: Anchor.bottomCenter,
                                            path: Assets.anim.dashIdle.path,
                                            data: SpriteAnimationData.sequenced(
                                              amount: 70,
                                              stepTime: 0.042,
                                              textureSize: Vector2(300, 336),
                                              amountPerRow: 10,
                                            ),
                                          ),
                                        )
                                      : mascot.mascot == Mascots.android
                                          ? SizedBox(
                                              width: 200,
                                              height: 400,
                                              child:
                                                  SpriteAnimationWidget.asset(
                                                images: Images(prefix: ''),
                                                anchor: Anchor.bottomCenter,
                                                path: Assets
                                                    .anim.androidIdle.path,
                                                data: SpriteAnimationData
                                                    .sequenced(
                                                  amount: 28,
                                                  stepTime: 0.042,
                                                  textureSize:
                                                      Vector2(250, 360),
                                                  amountPerRow: 7,
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              mascot.image,
                                              alignment: Alignment.bottomCenter,
                                              width: 200,
                                              height: 400,
                                            ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            ),
            Padding(
              padding: const EdgeInsets.all(45),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TODO(marwfair): Create a custom TabBarSelector.
                    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6422570849
                    // TabPageSelector(
                    //   controller: _tabController,
                    // ),
                    _TeamSelector(
                      mascots: widget.mascots,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TeamSelector extends StatelessWidget {
  const _TeamSelector({
    required this.mascots,
  });

  final List<Mascot> mascots;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = context.select((TeamSelectionCubit cubit) => cubit.state);

    return Column(
      children: [
        SizedBox(
          width: 302,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: index > 0
                    ? () {
                        context
                            .read<TeamSelectionCubit>()
                            .selectTeam(index - 1);
                      }
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Flexible(
                child: Text(
                  mascots[index].name,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              IconButton(
                onPressed: index < mascots.length - 1
                    ? () {
                        context
                            .read<TeamSelectionCubit>()
                            .selectTeam(index + 1);
                      }
                    : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // TODO(marwfair): Get the team player count.
        // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6422631645
        const Text('10000 players'),
        const SizedBox(
          height: 32,
        ),
        _SubmitButton(mascots[index]),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton(this.mascot);

  final Mascot mascot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return OutlinedButton(
      onPressed: () {
        context
            .flow<GameIntroStatus>()
            .update((state) => GameIntroStatus.enterInitials);
        context.read<CrosswordBloc>().add(MascotSelected(mascot.mascot));
      },
      child: Text(
        l10n.joinTeam(mascot.name),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class Mascot {
  const Mascot({
    required this.mascot,
    required this.name,
    required this.image,
    required this.gradientColors,
  });

  final Mascots mascot;
  final String name;
  final String image;
  final List<Color> gradientColors;
}

class GradientAnimation extends StatefulWidget {
  const GradientAnimation({
    required this.mascot,
    required this.width,
    required this.height,
    super.key,
  });

  final Mascot mascot;
  final double width;
  final double height;

  @override
  State<GradientAnimation> createState() => _GradientAnimationState();
}

class _GradientAnimationState extends State<GradientAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _animation = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: .3, end: 1.3),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: -.3, end: .3),
          weight: 1,
        ),
      ],
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: widget.mascot.gradientColors,
                  stops: [
                    _animation.value - .3,
                    _animation.value,
                    _animation.value + .3,
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Assets.images.gradient.svg(
                width: widget.width,
                height: widget.height,
              ),
            );
          },
        ),
        Assets.images.platformLarge.image(
          width: widget.width,
          height: widget.height,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
