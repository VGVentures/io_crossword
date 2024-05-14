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

    final textTheme = Theme.of(context).textTheme;
    const linkColor = IoCrosswordColors.linkBlue;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '${l10n.learn} ',
        style: textTheme.titleMedium,
        children: [
          TextSpan(
            text: l10n.howMade,
            style: textTheme.titleMedium?.copyWith(
              color: linkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(ProjectDetailsLinks.blogPost),
          ),
          TextSpan(text: ' ${l10n.and} '),
          TextSpan(
            text: l10n.openSourceCode,
            style: textTheme.titleMedium?.copyWith(
              color: linkColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(ProjectDetailsLinks.github),
          ),
          const TextSpan(
            text: '.',
          ),
        ],
      ),
    );
  }
}
