import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HowToPlayContent extends StatefulWidget {
  const HowToPlayContent({super.key});

  @override
  State<HowToPlayContent> createState() => _AboutHowToPlayContentState();
}

class _AboutHowToPlayContentState extends State<HowToPlayContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: context.read<HowToPlayCubit>().state,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final howToPlaySteps = [
      HowToPlayStep(
        title: l10n.aboutHowToPlayFirstInstructionsTitle,
        message: l10n.aboutHowToPlayFirstInstructions,
        image: Assets.images.howToPlayFindAWord.path,
      ),
      HowToPlayStep(
        title: l10n.aboutHowToPlaySecondInstructionsTitle,
        message: l10n.aboutHowToPlaySecondInstructions,
        image: Assets.images.howToPlayAnswer.path,
      ),
      HowToPlayStep(
        title: l10n.aboutHowToPlayThirdInstructionsTitle,
        message: l10n.aboutHowToPlayThirdInstructions,
        image: Assets.images.howToPlayStreak.path,
      ),
      HowToPlayStep(
        title: l10n.aboutHowToPlayFourthInstructionsTitle,
        message: l10n.aboutHowToPlayFourthInstructions,
        image: Assets.images.howToPlayHints.path,
      ),
      HowToPlayStep(
        title: l10n.aboutHowToPlayFifthInstructionsTitle,
        message: l10n.aboutHowToPlayFifthInstructions,
        image: Assets.images.howToPlayBadge.path,
      ),
    ];

    return BlocConsumer<HowToPlayCubit, int>(
      listener: (context, state) {
        _tabController.animateTo(
          state,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: IoCrosswordColors.black,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: howToPlaySteps,
                  ),
                ),
                Flexible(
                  child: _TabSelector(
                    tabController: _tabController,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TabSelector extends StatelessWidget {
  const _TabSelector({
    required this.tabController,
  });

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final index = context.select((HowToPlayCubit cubit) => cubit.state);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: index > 0
              ? () {
                  context.read<HowToPlayCubit>().updateIndex(index - 1);
                }
              : null,
          child: Text(
            l10n.backButtonLabel,
            style: TextStyle(
              color: index > 0
                  ? IoCrosswordColors.seedWhite
                  : IoCrosswordColors.softGray,
            ),
          ),
        ),
        TabPageSelector(
          controller: tabController,
        ),
        GestureDetector(
          onTap: index < tabController.length - 1
              ? () {
                  context.read<HowToPlayCubit>().updateIndex(index + 1);
                }
              : null,
          child: Text(
            index < tabController.length - 1
                ? l10n.nextButtonLabel
                : l10n.doneButtonLabel,
            style: TextStyle(
              color: index < tabController.length - 1
                  ? IoCrosswordColors.seedWhite
                  : IoCrosswordColors.softGray,
            ),
          ),
        ),
      ],
    );
  }
}

class HowToPlayStep extends StatelessWidget {
  const HowToPlayStep({
    required this.title,
    required this.message,
    required this.image,
    super.key,
  });

  final String title;

  final String message;

  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 24),
        Flexible(
          child: Image.asset(image),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Text(
            message,
            maxLines: 3,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
