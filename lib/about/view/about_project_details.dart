import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword/widget/widget.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class AboutProjectDetails extends StatelessWidget {
  const AboutProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).textTheme;
    const linkColor = IoCrosswordColors.linkBlue;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
        child: Column(
          children: [
            // TODO(Ayad): add real image
            Container(
              height: 153,
              color: Colors.grey,
              width: double.infinity,
              child: const Icon(Icons.image, size: 50),
            ),
            const SizedBox(height: 24),
            const HowMade(),
            const SizedBox(height: 24),
            Text(
              '${l10n.otherLinks}:',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: 'Google I/O',
                style: textTheme.bodyLarge?.copyWith(
                  color: linkColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.launchUrl(ProjectDetailsLinks.googleIO);
                  },
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: l10n.privacyPolicy,
                style: textTheme.bodyLarge?.copyWith(
                  color: linkColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.launchUrl(ProjectDetailsLinks.privacyPolicy);
                  },
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: l10n.termsOfService,
                style: textTheme.bodyLarge?.copyWith(
                  color: linkColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.launchUrl(ProjectDetailsLinks.termsOfService);
                  },
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                text: l10n.faqs,
                style: textTheme.bodyLarge?.copyWith(
                  color: linkColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    context.launchUrl(ProjectDetailsLinks.faqs);
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
