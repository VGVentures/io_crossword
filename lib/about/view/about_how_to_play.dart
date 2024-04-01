part of 'about_view.dart';

class AboutHowToPlayContent extends StatelessWidget {
  @visibleForTesting
  const AboutHowToPlayContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DefaultTabController(
      length: 5,
      child: Padding(
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

            // TODO(Ayad): If the new design can't use the theme we need to remove
            FilledButton.icon(
              icon: const Icon(Icons.play_circle, size: 18),
              label: Text(l10n.playNow),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TabSelector extends StatelessWidget {
  const TabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
        TabPageSelector(),
      ],
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
