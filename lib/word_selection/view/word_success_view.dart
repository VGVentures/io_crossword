import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/about/link/about_links.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword/word_selection/word_selection.dart'
    hide WordUnselected;
import 'package:io_crossword/word_selection/word_selection.dart' as selection;
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template word_success_view}
/// Displays a player's successful word guess.
/// {@endtemplate}
class WordSuccessView extends StatelessWidget {
  /// {@macro word_success_view}
  const WordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);
    return switch (layout) {
      IoLayoutData.large => const WordSelectionSuccessLargeView(),
      IoLayoutData.small => const WordSelectionSuccessSmallView(),
    };
  }
}

@visibleForTesting
class WordSelectionSuccessLargeView extends StatelessWidget {
  @visibleForTesting
  const WordSelectionSuccessLargeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);
    if (selectedWord == null) return const SizedBox.shrink();

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
            selectedWord.word.answer!.toUpperCase(),
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

@visibleForTesting
class WordSelectionSuccessSmallView extends StatelessWidget {
  @visibleForTesting
  const WordSelectionSuccessSmallView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord =
        context.select((WordSelectionBloc bloc) => bloc.state.word);
    if (selectedWord == null) return const SizedBox.shrink();

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
                      selectedWord.word.answer!.toUpperCase(),
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
        const CloseWordSelectionIconButton(),
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
    final points =
        context.select((WordSelectionBloc bloc) => bloc.state.wordPoints);
    final rank = context.select((PlayerBloc bloc) => bloc.state.rank);
    final totalScore =
        context.select((PlayerBloc bloc) => bloc.state.player.score);
    final streak =
        context.select((PlayerBloc bloc) => bloc.state.player.streak);

    return Column(
      children: [
        if (points != null)
          _StatsRow(
            title: l10n.points,
            icon: Icons.stars,
            value: points.toDisplayNumber(),
          ),
        const SizedBox(height: 12),
        _StatsRow(
          title: l10n.streak,
          icon: Icons.local_fire_department,
          value: streak.toDisplayNumber(),
        ),
        const SizedBox(height: 12),
        _StatsRow(
          title: l10n.rank,
          icon: IoIcons.trophy,
          value: rank.toDisplayNumber(),
        ),
        const SizedBox(height: 12),
        _StatsRow(
          title: l10n.totalScore,
          icon: Icons.stars,
          value: totalScore.toDisplayNumber(),
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
        context.read<WordSelectionBloc>().add(const selection.WordUnselected());
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
