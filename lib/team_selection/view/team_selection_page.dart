import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart' hide Axis;
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
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
    final layout = IoLayout.of(context);

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        actions: (context) => const MuteButton(),
      ),
      body: BlocBuilder<TeamSelectionCubit, TeamSelectionState>(
        builder: (context, state) => switch (layout) {
          IoLayoutData.small => const _TeamSelectorSmall(),
          IoLayoutData.large => const _TeamSelectorLarge(),
        },
      ),
    );
  }
}

class _TeamSelectorLarge extends StatelessWidget {
  const _TeamSelectorLarge();

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

    return BlocBuilder<TeamSelectionCubit, TeamSelectionState>(
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
                      child: SizedBox(
                        width: tileWidth,
                        height: platformTileHeight,
                        child: TeamSelectionMascotPlatform(
                          mascot: Mascots.dash,
                          selected: state.index == Mascots.dash.index,
                        ),
                      ),
                    ),
                    Positioned(
                      top: platformTileHeight,
                      left: tileWidth,
                      child: SizedBox(
                        width: tileWidth,
                        height: platformTileHeight,
                        child: TeamSelectionMascotPlatform(
                          mascot: Mascots.sparky,
                          selected: state.index == Mascots.sparky.index,
                        ),
                      ),
                    ),
                    Positioned(
                      top: platformTileHeight,
                      left: tileWidth * 3,
                      child: SizedBox(
                        width: tileWidth,
                        height: platformTileHeight,
                        child: TeamSelectionMascotPlatform(
                          mascot: Mascots.android,
                          selected: state.index == Mascots.android.index,
                        ),
                      ),
                    ),
                    Positioned(
                      top: bottomPlatformTileTopPosition,
                      left: tileWidth * 4,
                      child: SizedBox(
                        width: tileWidth,
                        height: platformTileHeight,
                        child: TeamSelectionMascotPlatform(
                          mascot: Mascots.dino,
                          selected: state.index == Mascots.dino.index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              child: SizedBox(
                // Width of the mascots is 5 tiles. Subtract half a tile to
                // center the mascots.
                width: (tileWidth * 5) - (tileWidth * .5),
                height: tileHeight * 3,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: tileHeight / 2,
                      child: SizedBox(
                        width: mascotWidth,
                        height: mascotHeight,
                        child: TeamSelectionMascot(Mascots.dash),
                      ),
                    ),
                    Positioned(
                      left: tileWidth,
                      bottom: tileHeight + (tileHeight / 2),
                      child: SizedBox(
                        width: mascotWidth,
                        height: mascotHeight,
                        child: TeamSelectionMascot(Mascots.sparky),
                      ),
                    ),
                    Positioned(
                      left: tileWidth * 3,
                      bottom: tileHeight + (tileHeight / 2),
                      child: SizedBox(
                        width: mascotWidth,
                        height: mascotHeight,
                        child: TeamSelectionMascot(Mascots.android),
                      ),
                    ),
                    Positioned(
                      left: tileWidth * 4,
                      bottom: tileHeight / 2,
                      child: SizedBox(
                        width: mascotWidth,
                        height: mascotHeight,
                        child: TeamSelectionMascot(Mascots.dino),
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
            const Padding(
              padding: EdgeInsets.all(45),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TeamSelector(),
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
  const _TeamSelectorSmall();

  static const tileWidth = 366.0;
  static const tileHeight = 209.0;

  static const platformTileHeight = 231.0;

  @override
  State<_TeamSelectorSmall> createState() => _TeamSelectorSmallState();
}

class _TeamSelectorSmallState extends State<_TeamSelectorSmall>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          context.read<TeamSelectionCubit>().state.index.toDouble() *
              (_TeamSelectorSmall.tileWidth * 2),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final halfScreenWidth = screenWidth / 2;

    return BlocConsumer<TeamSelectionCubit, TeamSelectionState>(
      listener: (context, state) {
        _scrollController.animateTo(
          state.index * (_TeamSelectorSmall.tileWidth * 2),
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
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                // The width of the background board is 15x12 tiles. This is
                // a little bigger than we need to make sure the grid shows
                // when the mascots at the ends are selected and when the
                // user is zoomed out.
                width: _TeamSelectorSmall.tileWidth * 15,
                height: _TeamSelectorSmall.tileHeight * 12,
                child: Stack(
                  children: [
                    // If the width of the window changes, we need to
                    // caclulate the edge of the background to keep the
                    // mascots in the center.
                    Positioned.fill(
                      left: (screenWidth * 1 +
                              (_TeamSelectorSmall.tileWidth * .001)) -
                          (_TeamSelectorSmall.tileWidth * 8),
                      // Move the board a half a tile up to align the
                      // mascots a little higher.
                      top: -(_TeamSelectorSmall.tileHeight / 2),
                      child: Image.asset(
                        Assets.images.tileLarge.path,
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                    Positioned.fill(
                      left: halfScreenWidth - _TeamSelectorSmall.tileWidth / 2,
                      bottom: -((_TeamSelectorSmall.tileHeight / 2) -
                          (_TeamSelectorSmall.platformTileHeight -
                              _TeamSelectorSmall.tileHeight)),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          // 4 platform tiles with a tile in between.
                          width: _TeamSelectorSmall.tileWidth * 7,
                          child: Stack(
                            children: [
                              _SmallPlatform(Mascots.dash),
                              Positioned(
                                left: _TeamSelectorSmall.tileWidth * 2,
                                child: _SmallPlatform(Mascots.sparky),
                              ),
                              Positioned(
                                left: _TeamSelectorSmall.tileWidth * 4,
                                child: _SmallPlatform(Mascots.android),
                              ),
                              Positioned(
                                left: _TeamSelectorSmall.tileWidth * 6,
                                child: _SmallPlatform(Mascots.dino),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      left: halfScreenWidth - 100,
                      top: -_TeamSelectorSmall.tileHeight -
                          (_TeamSelectorSmall.tileHeight / 2),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: _TeamSelectorSmall.tileWidth * 7,
                          height: 400,
                          child: Stack(
                            children: [
                              Positioned(
                                child: SizedBox(
                                  width: 200,
                                  height: 400,
                                  child: TeamSelectionMascot(Mascots.dash),
                                ),
                              ),
                              Positioned(
                                left: _TeamSelectorSmall.tileWidth * 2,
                                child: SizedBox(
                                  width: 200,
                                  height: 400,
                                  child: TeamSelectionMascot(Mascots.sparky),
                                ),
                              ),
                              Positioned(
                                left: _TeamSelectorSmall.tileWidth * 4,
                                child: SizedBox(
                                  width: 200,
                                  height: 400,
                                  child: TeamSelectionMascot(Mascots.android),
                                ),
                              ),
                              Positioned(
                                left: _TeamSelectorSmall.tileWidth * 6,
                                child: SizedBox(
                                  width: 200,
                                  height: 400,
                                  child: TeamSelectionMascot(Mascots.dino),
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
            ),
            const Padding(
              padding: EdgeInsets.all(45),
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
                    _TeamSelector(),
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
  const _TeamSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index =
        context.select((TeamSelectionCubit cubit) => cubit.state.index);

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
                  Mascots.values[index].teamMascot.name,
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              IconButton(
                onPressed: index < Mascots.values.length - 1
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
        _SubmitButton(Mascots.values[index]),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton(this.mascot);

  final Mascots mascot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton(
      onPressed: () {
        context
            .flow<GameIntroStatus>()
            .update((state) => GameIntroStatus.enterInitials);
        context.read<PlayerBloc>().add(MascotSelected(mascot));
        context.read<AudioController>().playSfx(Assets.music.startButton1);
      },
      child: Text(
        l10n.joinTeam(mascot.teamMascot.name),
      ),
    );
  }
}

extension TeamMascot on Mascots {
  Team get teamMascot {
    switch (this) {
      case Mascots.dash:
        return const DashTeam();
      case Mascots.sparky:
        return const SparkyTeam();
      case Mascots.android:
        return const AndroidTeam();
      case Mascots.dino:
        return const DinoTeam();
    }
  }
}

class _SmallPlatform extends StatelessWidget {
  const _SmallPlatform(
    this.mascot,
  );

  final Mascots mascot;

  @override
  Widget build(BuildContext context) {
    final index =
        context.select((TeamSelectionCubit cubit) => cubit.state.index);

    return SizedBox(
      width: _TeamSelectorSmall.tileWidth,
      height: _TeamSelectorSmall.platformTileHeight,
      child: TeamSelectionMascotPlatform(
        mascot: mascot,
        selected: index == mascot.index,
      ),
    );
  }
}
