import 'package:flutter/material.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ShareScorePage extends StatelessWidget {
  const ShareScorePage({super.key});

  static Future<void> showModal(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return const ShareScorePage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: IoCrosswordCard(
        maxWidth: 340,
        maxHeight: 598,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.ios_share,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.shareYourScore,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall.medium,
                  ),
                  const Expanded(child: SizedBox()),
                  const CloseButton(),
                ],
              ),
              const SizedBox(height: IoCrosswordSpacing.xlgsm),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItem(
                    label: l10n.rank,
                    info: 'info',
                    icon: IoIcons.trophy,
                  ),
                  _InfoItem(
                    label: l10n.streak,
                    info: 'info',
                    icon: IoIcons.trophy,
                  ),
                  _InfoItem(
                    label: l10n.points,
                    info: 'info',
                    icon: IoIcons.trophy,
                  ),
                ],
              ),
              const SizedBox(height: IoCrosswordSpacing.xlgsm),
              Text(
                l10n.shareOn,
              ),
              const SizedBox(height: IoCrosswordSpacing.lg * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(Assets.images.linkedin.path),
                  Image.asset(Assets.images.instagram.path),
                  Image.asset(Assets.images.twitter.path),
                  Image.asset(Assets.images.facebook.path),
                ],
              )
            ],
          ),
        ),
      ),
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
          children: [
            Icon(icon),
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
