import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/project_details/link/project_details_links.dart';
import 'package:io_crossword/share/share.dart';
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
          url: ProjectDetailsLinks.crossword,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeData = Theme.of(context);

    return Column(
      children: [
        const ShareImage(),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        Text(
          l10n.shareScoreContent,
          textAlign: TextAlign.center,
          style: themeData.textTheme.bodySmall.regular,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        const PlayerInitials(),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        const ScoreInformation(),
        const SizedBox(height: IoCrosswordSpacing.xxlg),
      ],
    );
  }
}
