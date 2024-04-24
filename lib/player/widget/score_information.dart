import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ScoreInformation extends StatelessWidget {
  const ScoreInformation({
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    super.key,
  });

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final player = context.select((PlayerBloc bloc) => bloc.state.player);
    final rank = context.select((PlayerBloc bloc) => bloc.state.rank);

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        _InfoItem(
          label: l10n.rank,
          info: rank.toDisplayNumber(),
          icon: IoIcons.trophy,
        ),
        _InfoItem(
          label: l10n.streak,
          info: player.streak.toDisplayNumber(),
          icon: Icons.local_fire_department,
        ),
        _InfoItem(
          label: l10n.points,
          info: player.score.toDisplayNumber(),
          icon: Icons.stars_rounded,
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.info,
    required this.icon,
  });

  final String label;
  final String info;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          label,
          style: textTheme.labelMedium.regular,
        ),
        const SizedBox(height: 13.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 7.5),
            Text(
              info,
              style: textTheme.labelSmall.regular,
            ),
          ],
        ),
      ],
    );
  }
}
