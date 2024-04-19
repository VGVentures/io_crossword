part of '../view/end_game_view.dart';

@visibleForTesting
class LeaderboardButton extends StatelessWidget {
  @visibleForTesting
  const LeaderboardButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // todo change color border
    return OutlinedButton(
      onPressed: () {
        Navigator.push(context, LeaderboardPage.route());
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.leaderboard),
          const SizedBox(width: 6),
          const Icon(IoIcons.trophy, size: 20),
        ],
      ),
    );
  }
}
