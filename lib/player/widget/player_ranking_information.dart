import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/leaderboard/view/leaderboard_page.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class PlayerRankingInformation extends StatelessWidget {
  const PlayerRankingInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final rank = context.select((PlayerBloc bloc) => bloc.state.rank);
    final score = context.select((PlayerBloc bloc) => bloc.state.player.score);
    final streak =
        context.select((PlayerBloc bloc) => bloc.state.player.streak);

    return SegmentedButton(
      emptySelectionAllowed: true,
      segments: [
        ButtonSegment(
          value: rank,
          label: Text(rank.toDisplayNumber()),
          icon: const Icon(IoIcons.trophy),
        ),
        ButtonSegment(
          value: score,
          label: Text(score.toDisplayNumber()),
          icon: const Icon(Icons.stars_rounded),
        ),
        ButtonSegment(
          value: streak,
          label: Text(streak.toDisplayNumber()),
          icon: const Icon(Icons.local_fire_department),
        ),
      ],
      selected: const {},
      onSelectionChanged: (_) {
        Navigator.push(context, LeaderboardPage.route());
      },
    );
  }
}
