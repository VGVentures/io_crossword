part of 'end_game_page.dart';

@visibleForTesting
class EndGameContent extends StatelessWidget {
  @visibleForTesting
  const EndGameContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).io.textStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const EndGameImage(),
        const SizedBox(height: 24),
        Text(
          l10n.thanksForContributing,
          style: textTheme.heading1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const HowMade(),
        const SizedBox(height: 24),
        const Center(
          child: PlayerInitials(),
        ),
        const SizedBox(height: 24),
        const ScoreInformation(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ],
    );
  }
}

@visibleForTesting
class ActionButtonsEndGame extends StatelessWidget {
  @visibleForTesting
  const ActionButtonsEndGame({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        SizedBox(
          height: 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.ios_share_sharp, size: 20),
                  label: Text(l10n.share),
                  onPressed: () {
                    ShareScorePage.showModal(context);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context
                        .read<AudioController>()
                        .playSfx(Assets.music.startButton1);
                    Navigator.of(context).pushReplacement<void, void>(
                      CrosswordPage.route(),
                    );
                  },
                  icon: const Icon(Icons.gamepad),
                  label: Text(l10n.playAgain),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.or,
          style: Theme.of(context).io.textStyles.body3.copyWith(
                color: IoCrosswordColors.softGray,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.claimBadgeContributing,
          textAlign: TextAlign.center,
          style: Theme.of(context).io.textStyles.body3.copyWith(
                color: IoCrosswordColors.softGray,
              ),
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () {
            context.launchUrl(ProjectDetailsLinks.claimBadge);
          },
          label: Text(l10n.claimBadge),
          icon: const Icon(IoIcons.google, size: 20),
        ),
      ],
    );
  }
}

@visibleForTesting
class EndGameImage extends StatelessWidget {
  @visibleForTesting
  const EndGameImage({super.key});

  @override
  Widget build(BuildContext context) {
    final mascot =
        context.select((PlayerBloc bloc) => bloc.state.player.mascot);

    final image = switch (mascot) {
      Mascot.dash => Assets.images.endGameDash,
      Mascot.android => Assets.images.endGameAndroid,
      Mascot.dino => Assets.images.endGameDino,
      Mascot.sparky => Assets.images.endGameSparky,
    };

    return image.image(
      fit: BoxFit.fitWidth,
    );
  }
}
