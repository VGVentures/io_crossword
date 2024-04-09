import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
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

class TeamSelectionView extends StatelessWidget {
  const TeamSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final mascots = [
      Mascot(
        mascot: Mascots.dash,
        name: 'Dash',
        image: Assets.images.dash.path,
      ),
      Mascot(
        mascot: Mascots.sparky,
        name: 'Sparky',
        image: Assets.images.sparky.path,
      ),
      Mascot(
        mascot: Mascots.android,
        name: 'Android',
        image: Assets.images.android.path,
      ),
      Mascot(
        mascot: Mascots.dino,
        name: 'Dino',
        image: Assets.images.dino.path,
      ),
    ];

    final layout = IoLayout.of(context);

    switch (layout) {
      case IoLayoutData.small:
        return _TeamSelectorSmall(mascots);
      case IoLayoutData.large:
        return _TeamSelectorLarge(mascots);
    }
  }
}

class _TeamSelectorLarge extends StatelessWidget {
  const _TeamSelectorLarge(this.mascots);

  final List<Mascot> mascots;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocBuilder<TeamSelectionCubit, int>(
      builder: (context, state) {
        return Stack(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: mascots
                    .map(
                      (mascot) => ColoredBox(
                        color: state == mascots.indexOf(mascot)
                            ? Colors.blue
                            : Colors.transparent,
                        child: Image.asset(
                          mascot.image,
                          width: 100,
                        ),
                      ),
                    )
                    .toList(),
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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: widget.mascots.length,
      vsync: this,
      initialIndex: context.read<TeamSelectionCubit>().state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamSelectionCubit, int>(
      listener: (context, state) {
        _tabController.animateTo(
          state,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      builder: (context, state) {
        return Stack(
          children: [
            TabBarView(
              controller: _tabController,
              children: widget.mascots
                  .map(
                    (mascot) => mascot.mascot == Mascots.android
                        ? SpriteAnimationWidget.asset(
                            images: Images(prefix: ''),
                            path: Assets.anim.androidIdle.path,
                            data: SpriteAnimationData.sequenced(
                              amount: 28,
                              stepTime: 0.042,
                              textureSize: Vector2(597, 597),
                              amountPerRow: 7,
                            ),
                          )
                        : Image.asset(mascot.image),
                  )
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(45),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabPageSelector(
                      controller: _tabController,
                    ),
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
              Text(
                mascots[index].name,
                style: theme.textTheme.headlineLarge,
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
        context.read<GameIntroBloc>().add(MascotSubmitted(mascot.mascot));
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
  });

  final Mascots mascot;
  final String name;
  final String image;
}
