part of 'leaderboard_page.dart';

class LeaderboardSuccess extends StatelessWidget {
  @visibleForTesting
  const LeaderboardSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final players =
        context.select((LeaderboardBloc bloc) => bloc.state.players);

    final layout = IoLayout.of(context);

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
                          iconData: Icons.print,
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
                    // TODO(Ayad): check current user
                    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6400343873
                    // if (player.userId == user.id) {
                    //   return Padding(
                    //     padding: const EdgeInsets.only(
                    //       bottom: 16,
                    //     ),
                    //     child: CurrentUserPosition(
                    //       player: player,
                    //       rank: index + 1,
                    //     ),
                    //   );
                    // }

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
                // TODO(Ayad): check current user
                // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6400343873
                // if ()
                //   Padding(
                //     padding: const EdgeInsets.only(top: 8, bottom: 16),
                //     child: CurrentUserPosition(
                //       player: players.last,
                //       rank: 320,
                //     ),
                //   ),

                if (layout == IoLayoutData.small)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 17.5,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.gamepad),
                      label: Text(l10n.playAgain),
                    ),
                  ),
              ],
            ),
          ),
        ),
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

  final LeaderboardPlayer player;
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
              Text('${l10n.you}:'),
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

  final LeaderboardPlayer player;
  final int rank;

  @override
  Widget build(BuildContext context) {
    // TODO(Ayad): show the correct style based on the players team
    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6400331391
    final style = IoPlayerAliasStyle(
      backgroundColor: rank.isOdd
          ? IoCrosswordColors.androidGreen
          : IoCrosswordColors.flutterBlue,
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(0.36)),
      margin: const EdgeInsets.all(0.5),
      boxSize: const Size.square(30),
    );

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rank.toDisplayNumber(),
              ),
              IoPlayerAlias(
                player.initials.toUpperCase(),
                style: style,
              ),
              const SizedBox(),
            ],
          ),
        ),

        // TODO(Ayad): add missing streak in [LeaderboardPlayer]
        // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6400331391
        Expanded(
          child: Text(1524.toDisplayNumber()),
        ),
        Expanded(
          child: Text(
            player.score.toDisplayNumber(),
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
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
