part of 'about_view.dart';

class AboutHowToPlayContent extends StatelessWidget {
  @visibleForTesting
  const AboutHowToPlayContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final instructions = [
      l10n.aboutHowToPlayFirstInstructions,
      l10n.aboutHowToPlaySecondInstructions,
      l10n.aboutHowToPlayThirdInstructions,
      l10n.aboutHowToPlayFourthInstructions,
      l10n.aboutHowToPlayFifthInstructions,
    ];

    return DefaultTabController(
      length: instructions.length,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: instructions
                    .map((instruction) => HowToPlaySteps(title: instruction))
                    .toList(),
              ),
            ),
            Builder(
              builder: (context) {
                return _TabSelector(
                  tabController: DefaultTabController.of(context),
                );
              },
            ),
            const SizedBox(height: 10),
            // TODO(Ayad): If the new design can't use the theme change
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

class _TabSelector extends StatefulWidget {
  const _TabSelector({
    required this.tabController,
  });

  final TabController tabController;

  @override
  State<_TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<_TabSelector> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.tabController.removeListener(_tabListener);
  }

  void _tabListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.tabController.index;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: index > 0
              ? () {
                  widget.tabController.animateTo(index - 1);
                }
              : null,
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
        const TabPageSelector(),
        IconButton(
          onPressed: index < widget.tabController.length - 1
              ? () {
                  widget.tabController.animateTo(index + 1);
                }
              : null,
          icon: const Icon(Icons.keyboard_arrow_right),
        ),
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
