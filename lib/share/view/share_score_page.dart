import 'package:flutter/material.dart';
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
    const style = IoWordStyle(
      backgroundColor: IoCrosswordColors.flutterBlue,
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: BorderRadius.all(Radius.circular(0.36)),
      margin: EdgeInsets.all(0.5),
      boxSize: Size.square(30),
    );

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
              // TODO(any): Update with new alias widget
              const IoWord('ABC', style: style),
              const SizedBox(height: IoCrosswordSpacing.xlgsm),
              const ScoreInfos(),
              const SizedBox(height: IoCrosswordSpacing.lg * 2),
              Text(
                l10n.shareOn,
              ),
              const SizedBox(height: IoCrosswordSpacing.xlgsm),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.linkedin),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.instagram),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.twitter),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.facebook),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreInfos extends StatelessWidget {
  @visibleForTesting
  const ScoreInfos({super.key});

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
