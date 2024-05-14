import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/link/project_details_links.dart';
import 'package:io_crossword/widget/widget.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ProjectDetailsView extends StatelessWidget {
  const ProjectDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.large => const ProjectDetailsLargeView(),
      IoLayoutData.small => const ProjectDetailsSmallView(),
    };
  }
}

@visibleForTesting
class ProjectDetailsLargeView extends StatelessWidget {
  @visibleForTesting
  const ProjectDetailsLargeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: IoCrosswordCard(
        maxWidth: 460,
        maxHeight: 540,
        child: ProjectDetailsContent(),
      ),
    );
  }
}

@visibleForTesting
class ProjectDetailsSmallView extends StatelessWidget {
  @visibleForTesting
  const ProjectDetailsSmallView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: ProjectDetailsContent(),
      ),
    );
  }
}

@visibleForTesting
class ProjectDetailsContent extends StatelessWidget {
  @visibleForTesting
  const ProjectDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).io.textStyles;
    const linkColor = IoCrosswordColors.linkBlue;
    final layout = IoLayout.of(context);
    final verticalSpacing = layout == IoLayoutData.small ? 24.0 : 40.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: layout == IoLayoutData.small
                      ? const _ProjectDetailsHeader()
                      : const SizedBox.shrink(),
                ),
                const SizedBox(width: 12),
                const CloseButton(),
              ],
            ),
          ),
          if (layout == IoLayoutData.small) ...[
            Container(
              height: 0.5,
              color: IoCrosswordColors.accessibleGrey,
            ),
            SizedBox(height: verticalSpacing),
          ],
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  if (layout == IoLayoutData.large)
                    const _ProjectDetailsHeader(),
                  if (layout == IoLayoutData.small)
                    // TODO(Ayad): add real image
                    Container(
                      height: 153,
                      color: Colors.grey,
                      width: double.infinity,
                      child: const Icon(Icons.image, size: 50),
                    ),
                  SizedBox(height: verticalSpacing),
                  const HowMade(),
                  SizedBox(height: verticalSpacing),
                  Text(
                    '${l10n.otherLinks}:',
                    style: textTheme.body,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Google I/O',
                      style: textTheme.body.copyWith(
                        color: linkColor,
                        decoration: TextDecoration.underline,
                        decorationColor: linkColor,
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
                      style: textTheme.body.copyWith(
                        color: linkColor,
                        decoration: TextDecoration.underline,
                        decorationColor: linkColor,
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
                      style: textTheme.body.copyWith(
                        color: linkColor,
                        decoration: TextDecoration.underline,
                        decorationColor: linkColor,
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
                      style: textTheme.body.copyWith(
                        color: linkColor,
                        decoration: TextDecoration.underline,
                        decorationColor: linkColor,
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
          ),
        ],
      ),
    );
  }
}

class _ProjectDetailsHeader extends StatelessWidget {
  const _ProjectDetailsHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).io.textStyles;

    return Text(
      l10n.projectDetails,
      style: textTheme.h2,
    );
  }
}
