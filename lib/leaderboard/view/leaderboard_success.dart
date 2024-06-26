part of 'leaderboard_page.dart';

class LeaderboardSuccess extends StatelessWidget {
  @visibleForTesting
  const LeaderboardSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final user = context.read<User>();

    final players =
        context.select((LeaderboardBloc bloc) => bloc.state.players);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _Title(
                          iconData: IoIcons.trophy,
                          title: l10n.rank,
                        ),
                      ),
                      Expanded(
                        child: _Title(
                          iconData: Icons.local_fire_department,
                          title: l10n.streak,
                        ),
                      ),
                      Expanded(
                        child: _Title(
                          mainAxisAlignment: MainAxisAlignment.end,
                          iconData: Icons.stars_rounded,
                          title: l10n.score,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ...players.mapIndexed(
                  (index, player) {
                    if (player.id == user.id) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        child: CurrentUserPosition(
                          player: player,
                          rank: index + 1,
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      child: UserLeaderboardRanking(
                        player: player,
                        rank: index + 1,
                      ),
                    );
                  },
                ),
                const CurrentPlayerNotTopRank(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurrentPlayerNotTopRank extends StatelessWidget {
  @visibleForTesting
  const CurrentPlayerNotTopRank({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.select((PlayerBloc bloc) => bloc.state.player);

    final rank = context.select(
      (PlayerBloc bloc) => bloc.state.rank,
    );

    if (rank <= 10) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: CurrentUserPosition(
        player: player,
        rank: rank,
      ),
    );
  }
}

class CurrentUserPosition extends StatelessWidget {
  @visibleForTesting
  const CurrentUserPosition({
    required this.player,
    required this.rank,
    super.key,
  });

  final Player player;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        cardTheme: theme.io.cardTheme.highlight,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.you}:',
                style: theme.io.textStyles.body4.medium?.copyWith(
                  color: IoCrosswordColors.softGray,
                ),
              ),
              UserLeaderboardRanking(
                player: player,
                rank: rank,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserLeaderboardRanking extends StatelessWidget {
  @visibleForTesting
  const UserLeaderboardRanking({
    required this.player,
    required this.rank,
    super.key,
  });

  final Player player;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final style = themeData.io.wordTheme.small.copyWith(
      backgroundColor: switch (player.mascot) {
        Mascot.dash => IoCrosswordColors.flutterBlue,
        Mascot.sparky => IoCrosswordColors.sparkyYellow,
        Mascot.dino => IoCrosswordColors.chromeRed,
        Mascot.android => IoCrosswordColors.androidGreen,
      },
    );

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 45,
                child: Text(
                  rank.toDisplayNumber(),
                  style: themeData.io.textStyles.body4,
                ),
              ),
              IoWord(
                player.initials,
                style: style,
              ),
              const SizedBox(),
            ],
          ),
        ),
        Expanded(
          child: Text(
            player.streak.toDisplayNumber(),
            style: themeData.io.textStyles.body4,
          ),
        ),
        Expanded(
          child: Text(
            player.score.toDisplayNumber(),
            style: themeData.io.textStyles.body4,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.iconData,
    required this.title,
    this.mainAxisAlignment,
  });

  final IconData iconData;
  final String title;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Icon(
          iconData,
          size: 20,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: Theme.of(context).io.textStyles.body4,
        ),
      ],
    );
  }
}
