part of 'end_game_page.dart';

@visibleForTesting
class EndGameContent extends StatelessWidget {
  @visibleForTesting
  const EndGameContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.thanksForContributing,
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const EndGameHowMade(),
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
                  onPressed: () {}, // coverage:ignore-line
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {}, // coverage:ignore-line
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
          style: Theme.of(context).textTheme.labelMedium.regular?.copyWith(
                color: IoCrosswordColors.softGray,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.claimBadgeContributing,
          style: Theme.of(context).textTheme.labelMedium.regular?.copyWith(
                color: IoCrosswordColors.softGray,
              ),
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: () {}, // coverage:ignore-line
          label: Text(l10n.developerProfile),
          icon: const Icon(IoIcons.google, size: 20),
        ),
      ],
    );
  }
}

@visibleForTesting
class EndGameHowMade extends StatelessWidget {
  @visibleForTesting
  const EndGameHowMade({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).textTheme;
    const linkColor = IoCrosswordColors.linkBlue;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '${l10n.learn} ',
        style: textTheme.titleMedium,
        children: [
          TextSpan(
            text: l10n.howMade,
            style: textTheme.titleMedium?.copyWith(
              color: linkColor,
            ),
            // TODO(Ayad): add link
            // recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(text: ' ${l10n.and} '),
          TextSpan(
            text: l10n.openSourceCode,
            style: textTheme.titleMedium?.copyWith(
              color: linkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.launchUrl(ProjectDetailsLinks.github);
              },
          ),
          const TextSpan(
            text: '.',
          ),
        ],
      ),
    );
  }
}
