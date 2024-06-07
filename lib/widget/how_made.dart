import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/extensions/context_ext.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/link/project_details_links.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HowItWasMade extends StatelessWidget {
  const HowItWasMade({super.key});

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
          TextSpan(text: '${l10n.learnHowThe} '),
          TextSpan(
            text: l10n.ioCrossword,
            style: textTheme.body.copyWith(color: linkColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(
                    ProjectDetailsLinks.developerPathway,
                  ),
          ),
          TextSpan(text: ' ${l10n.wasMade}.\n'),
          TextSpan(
            text: '${l10n.joinThe} ',
          ),
          TextSpan(
            text: l10n.geminiCompetition,
            style: textTheme.body.copyWith(color: linkColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.launchUrl(
                    ProjectDetailsLinks.geminiDeveloperCompetition,
                  ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
