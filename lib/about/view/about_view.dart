import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const AboutView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Center(
        child: IoCrosswordCard(
          maxHeight: 620,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.aboutCrossword,
                          style: textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const CloseButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TabBar(
                  tabs: [
                    Tab(
                      text: l10n.howToPlay,
                    ),
                    Tab(
                      text: l10n.projectDetails,
                    ),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      AboutHowToPlayContent(),
                      AboutProjectDetails(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutHowToPlayContent extends StatelessWidget {
  @visibleForTesting
  const AboutHowToPlayContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
      child: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                HowToPlaySteps(title: l10n.aboutHowToPlayFirstInstructions),
                HowToPlaySteps(title: l10n.aboutHowToPlaySecondInstructions),
                HowToPlaySteps(title: l10n.aboutHowToPlayThirdInstructions),
                HowToPlaySteps(title: l10n.aboutHowToPlayFourthInstructions),
                HowToPlaySteps(title: l10n.aboutHowToPlayFifthInstructions),
              ],
            ),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.play_circle),
            label: Text(l10n.playNow),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// TODO(Ayad): the images need to be added
class HowToPlaySteps extends StatelessWidget {
  const HowToPlaySteps({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // TODO(Ayad): add real image
          Container(
            height: 120,
            color: Colors.grey,
            width: double.infinity,
            child: const Icon(Icons.image, size: 50),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class AboutProjectDetails extends StatelessWidget {
  @visibleForTesting
  const AboutProjectDetails({super.key});

  Future<void> _launchUrl(String link, BuildContext context) async {
    final url = Uri.parse(link);

    if (!await canLaunchUrl(url)) {
      if (context.mounted) {
        final l10n = context.l10n;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(l10n.couldNotOpenUrl),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }

      throw Exception('Could not launch $url');
    }

    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final textTheme = Theme.of(context).textTheme;
    const linkColor = Color(0xFF1A73E8);

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
            RichText(
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
                      ..onTap = () {
                        // TODO(Ayad): add link
                      },
                  ),
                  TextSpan(text: ' ${l10n.and} '),
                  TextSpan(
                    text: l10n.openSourceCode,
                    style: textTheme.titleMedium?.copyWith(
                      color: linkColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        const link =
                            'https://github.com/VGVentures/io_crossword';
                        _launchUrl(link, context);
                      },
                  ),
                  const TextSpan(
                    text: '.',
                  ),
                ],
              ),
            ),
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
                    const link = 'https://io.google/2024';
                    _launchUrl(link, context);
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
                    const link = 'https://policies.google.com/privacy';
                    _launchUrl(link, context);
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
                    const link = 'https://policies.google.com/terms';
                    _launchUrl(link, context);
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
                    const link = 'https://flutter.dev/crossword';
                    _launchUrl(link, context);
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
