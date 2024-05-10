part of '../view/end_game_page.dart';

@visibleForTesting
class LeaderboardButton extends StatelessWidget {
  @visibleForTesting
  const LeaderboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final style = Theme.of(context).io.outlineButtonTheme.simpleBorder;

    return OutlinedButton(
      onPressed: () {
        context.read<AudioController>().playSfx(Assets.music.startButton1);
        Navigator.push(context, LeaderboardPage.route());
      },
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.leaderboard,
            style: TextStyle(
              color: style.foregroundColor?.resolve({}),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(IoIcons.trophy, size: 20),
        ],
      ),
    );
  }
}
