import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/share/widgets/widgets.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ShareScorePage extends StatelessWidget {
  const ShareScorePage({super.key});

  static Future<void> showModal(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;

        return ShareDialog(
          title: l10n.shareYourScore,
          content: const ShareScorePage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const style = IoPlayerAliasStyle(
      backgroundColor: IoCrosswordColors.flutterBlue,
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: BorderRadius.all(Radius.circular(0.36)),
      margin: EdgeInsets.all(0.5),
      boxSize: Size.square(30),
    );

    return Column(
      children: [
        const SizedBox(
          height: 153,
          child: Placeholder(),
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        Text(
          l10n.shareScoreContent,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall.regular,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        // TODO(any): Update with new alias widget
        const IoPlayerAlias('ABC', style: style),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        const ScoreInformation(),
      ],
    );
  }
}

class ScoreInformation extends StatelessWidget {
  @visibleForTesting
  const ScoreInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _InfoItem(
          label: l10n.rank,
          info: '320',
          icon: IoIcons.trophy,
        ),
        _InfoItem(
          label: l10n.streak,
          info: '222',
          icon: Icons.local_fire_department,
        ),
        _InfoItem(
          label: l10n.points,
          info: '100,000',
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
        const SizedBox(height: IoCrosswordSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: IoCrosswordColors.seedGreen,
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
