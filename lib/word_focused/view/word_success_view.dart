import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WordSuccessDesktopView extends StatelessWidget {
  const WordSuccessDesktopView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        iconButtonTheme: IconButtonThemeData(
          style: themeData.io.iconButtonTheme.filled,
        ),
      ),
      child: Column(
        children: [
          const _SuccessTopBar(),
          const SizedBox(height: 32),
          IoPlayerAlias(
            selectedWord.word.answer.toUpperCase(),
            style: themeData.io.playerAliasTheme.big,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 318),
                child: const Column(
                  children: [
                    _SuccessStats(),
                    SizedBox(height: 40),
                    _SuccessChallengeProgress(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 342),
            child: Text(
              l10n.claimBadgeDescription,
              style: IoCrosswordTextStyles.labelMD
                  .copyWith(color: IoCrosswordColors.softGray),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              OutlinedButton.icon(
                style: IoCrosswordTheme.geminiOutlinedButtonThemeData.style,
                onPressed: () {},
                icon: const Icon(Icons.person),
                label: Text(l10n.claimBadge),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.keepPlaying),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WordSuccessMobileView extends StatelessWidget {
  const WordSuccessMobileView(this.selectedWord, {super.key});

  final WordSelection selectedWord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        iconButtonTheme: IconButtonThemeData(
          style: themeData.io.iconButtonTheme.filled,
        ),
      ),
      child: Column(
        children: [
          const _SuccessTopBar(),
          const SizedBox(height: 32),
          IoPlayerAlias(
            selectedWord.word.answer.toUpperCase(),
            style: themeData.io.playerAliasTheme.big,
          ),
          const SizedBox(height: 40),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _SuccessStats(),
                  SizedBox(height: 40),
                  _SuccessChallengeProgress(),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: Text(l10n.keepPlaying),
          ),
          const SizedBox(width: 16),
          Text(
            'or',
            style: IoCrosswordTextStyles.labelMD
                .copyWith(color: IoCrosswordColors.softGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.claimBadgeDescription,
            style: IoCrosswordTextStyles.labelMD
                .copyWith(color: IoCrosswordColors.softGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: IoCrosswordTheme.geminiOutlinedButtonThemeData.style,
            onPressed: () {},
            icon: const Icon(Icons.person),
            label: Text(l10n.claimBadge),
          ),
        ],
      ),
    );
  }
}

class _SuccessTopBar extends StatelessWidget {
  const _SuccessTopBar();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          // TODO(any): Open share page
          onPressed: () {}, // coverage:ignore-line
          icon: const Icon(Icons.ios_share),
          style: themeData.io.iconButtonTheme.filled,
        ),
        Text(
          l10n.wordSolved,
          style: IoCrosswordTextStyles.headlineSM,
        ),
        IconButton(
          onPressed: () {
            context.read<CrosswordBloc>().add(const WordUnselected());
          },
          icon: const Icon(Icons.cancel),
          style: themeData.io.iconButtonTheme.filled,
        ),
      ],
    );
  }
}

class _SuccessStats extends StatelessWidget {
  const _SuccessStats();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // TODO(any): update icons and real values
    return Column(
      children: [
        _StatsRow(
          title: l10n.points,
          icon: Icons.stars,
          value: 'value',
        ),
        const SizedBox(height: 12),
        _StatsRow(
          title: l10n.streak,
          icon: Icons.local_fire_department,
          value: 'value',
        ),
        const SizedBox(height: 12),
        _StatsRow(
          title: l10n.rank,
          icon: IoIcons.icon_right,
          value: 'value',
        ),
        const SizedBox(height: 12),
        _StatsRow(
          title: l10n.totalScore,
          icon: Icons.stars,
          value: 'value',
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.title,
    required this.icon,
    required this.value,
  });

  final String title;

  final IconData icon;

  final String value;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: IoCrosswordTextStyles.labelMD,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: IoCrosswordTextStyles.labelMD,
            ),
          ],
        ),
      ],
    );
  }
}

class _SuccessChallengeProgress extends StatelessWidget {
  const _SuccessChallengeProgress();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChallengeBloc, ChallengeState, (int, int)>(
      selector: (state) => (state.solvedWords, state.totalWords),
      builder: (context, words) {
        return ChallengeProgress(
          solvedWords: words.$1,
          totalWords: words.$2,
        );
      },
    );
  }
}
