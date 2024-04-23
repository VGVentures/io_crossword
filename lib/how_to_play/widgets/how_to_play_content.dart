import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/team_selection/team_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HowToPlayContent extends StatefulWidget {
  const HowToPlayContent({
    required this.mascot,
    super.key,
  });

  final Mascots mascot;

  @override
  State<HowToPlayContent> createState() => _HowToPlayContentState();
}

class _HowToPlayContentState extends State<HowToPlayContent>
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
        key: const Key('how_to_play_step_1'),
        title: l10n.aboutHowToPlayFirstInstructionsTitle,
        message: l10n.aboutHowToPlayFirstInstructions,
        image: widget.mascot.teamMascot.howToPlayFindWord.path,
      ),
      HowToPlayStep(
        key: const Key('how_to_play_step_2'),
        title: l10n.aboutHowToPlaySecondInstructionsTitle,
        message: l10n.aboutHowToPlaySecondInstructions,
        image: widget.mascot.teamMascot.howToPlayAnswer.path,
      ),
      HowToPlayStep(
        key: const Key('how_to_play_step_3'),
        title: l10n.aboutHowToPlayThirdInstructionsTitle,
        message: l10n.aboutHowToPlayThirdInstructions,
        image: widget.mascot.teamMascot.howToPlayStreak.path,
      ),
      HowToPlayStep(
        key: const Key('how_to_play_step_4'),
        title: l10n.aboutHowToPlayFourthInstructionsTitle,
        message: l10n.aboutHowToPlayFourthInstructions,
        image: Assets.images.howToPlayHints.path,
      ),
      HowToPlayStep(
        key: const Key('how_to_play_step_5'),
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
            color: IoCrosswordColors.darkGray,
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: howToPlaySteps[state],
                  ),
                ),
                const SizedBox(height: 20),
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

  static const double textHeight = 66;

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: layout == IoLayoutData.small ? 153 : 172,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: IoCrosswordColors.mediumGray,
            ),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                child: Image.asset(
                  image,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: textHeight,
            child: Text(
              message,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
