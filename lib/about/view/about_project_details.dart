part of 'about_view.dart';

class AboutProjectDetails extends StatelessWidget {
  @visibleForTesting
  const AboutProjectDetails({super.key});

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
                    // TODO(Ayad): add link
                    // recognizer: TapGestureRecognizer()..onTap = () {},
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
                        context.launchUrl(link);
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
                    context.launchUrl(link);
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
                    context.launchUrl(link);
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
                    context.launchUrl(link);
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
                    context.launchUrl(link);
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
