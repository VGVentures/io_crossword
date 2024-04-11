import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/about/link/about_links.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/extensions/extensions.dart';
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
          const SuccessTopBar(),
          const SizedBox(height: 32),
          IoWord(
            selectedWord.word.answer.toUpperCase(),
            style: themeData.io.wordTheme.big,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 318),
                child: const Column(
                  children: [
                    SuccessStats(),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClaimBadgeButton(),
              SizedBox(width: 16),
              KeepPlayingButton(),
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
          const SuccessTopBar(),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 342),
                child: Column(
                  children: [
                    IoWord(
                      selectedWord.word.answer.toUpperCase(),
                      style: themeData.io.wordTheme.big,
                    ),
                    const SizedBox(height: 40),
                    const SuccessStats(),
                    const SizedBox(height: 40),
                    const _SuccessChallengeProgress(),
                    const SizedBox(height: 40),
                    const KeepPlayingButton(),
                    const SizedBox(height: 16),
                    Text(
                      l10n.or,
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
                    const ClaimBadgeButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
class SuccessTopBar extends StatelessWidget {
  @visibleForTesting
  const SuccessTopBar({super.key});

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

@visibleForTesting
class SuccessStats extends StatelessWidget {
  @visibleForTesting
  const SuccessStats({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // TODO(any): update to real values
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
          icon: IoIcons.trophy,
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

class KeepPlayingButton extends StatelessWidget {
  @visibleForTesting
  const KeepPlayingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return OutlinedButton.icon(
      onPressed: () {
        context.read<CrosswordBloc>().add(const WordUnselected());
      },
      icon: const Icon(
        Icons.gamepad,
        size: 20,
      ),
      label: Text(l10n.keepPlaying),
    );
  }
}

class ClaimBadgeButton extends StatelessWidget {
  @visibleForTesting
  const ClaimBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton.icon(
      style: IoCrosswordTheme.geminiOutlinedButtonThemeData.style,
      onPressed: () {
        context.launchUrl(AboutLinks.claimBadge);
      },
      icon: const Icon(
        IoIcons.google,
        size: 20,
      ),
      label: Text(l10n.claimBadge),
    );
  }
}
