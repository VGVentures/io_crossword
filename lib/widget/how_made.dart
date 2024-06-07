import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/extensions/context_ext.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/link/project_details_links.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HowMadeAndOpenSource extends StatelessWidget {
  const HowMadeAndOpenSource({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).io.textStyles;
    const linkColor = IoCrosswordColors.linkBlue;
    const textColor = IoCrosswordColors.seedWhite;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textTheme.body.copyWith(color: textColor),
        children: [
          TextSpan(text: '${l10n.learn} '),
          TextSpan(
            text: l10n.howMade,
            style: textTheme.body.copyWith(color: linkColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(ProjectDetailsLinks.blogPost),
          ),
          TextSpan(text: ' ${l10n.and} '),
          TextSpan(
            text: l10n.openSourceCode,
            style: textTheme.body.copyWith(color: linkColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(ProjectDetailsLinks.github),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}

class HowMadeAndJoinCompetition extends StatelessWidget {
  const HowMadeAndJoinCompetition({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).io.textStyles;
    const linkColor = IoCrosswordColors.linkBlue;
    const textColor = IoCrosswordColors.seedWhite;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: textTheme.body.copyWith(color: textColor),
        children: [
          TextSpan(text: '${l10n.learn} '),
          TextSpan(
            text: l10n.howMade,
            style: textTheme.body.copyWith(color: linkColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(ProjectDetailsLinks.blogPost),
          ),
          const TextSpan(text: '.\n'),
          TextSpan(
            text: l10n.joinGeminiCompetition,
            style: textTheme.body.copyWith(color: linkColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context
                  .launchUrl(ProjectDetailsLinks.geminiDeveloperCompetition),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
