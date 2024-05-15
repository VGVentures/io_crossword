import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/extensions/context_ext.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/link/project_details_links.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HowMade extends StatelessWidget {
  const HowMade({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).io.textStyles;
    const linkColor = IoCrosswordColors.linkBlue;
    const textColor = IoCrosswordColors.seedWhite;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '${l10n.learn} ',
        style: textTheme.body.copyWith(
          color: textColor,
        ),
        children: [
          TextSpan(
            text: l10n.howMade,
            style: textTheme.body.copyWith(
              color: linkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(ProjectDetailsLinks.blogPost),
          ),
          TextSpan(
            text: ' ${l10n.and} ',
            style: textTheme.body..copyWith(),
          ),
          TextSpan(
            text: l10n.openSourceCode,
            style: textTheme.body.copyWith(
              color: linkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(ProjectDetailsLinks.github),
          ),
          TextSpan(
            text: '.',
            style: textTheme.body.copyWith(),
          ),
        ],
      ),
    );
  }
}
