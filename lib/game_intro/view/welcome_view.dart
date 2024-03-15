import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  static Page<void> page() {
    return const MaterialPage(child: WelcomeView());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Placeholder(fallbackHeight: 150),
        const SizedBox(height: IoCrosswordSpacing.xlg),
        Text(
          l10n.welcome,
          style: IoCrosswordTextStyles.headlineMD,
        ),
        const SizedBox(height: IoCrosswordSpacing.sm),
        Text(
          l10n.welcomeSubtitle,
          style: IoCrosswordTextStyles.bodyLG,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        const RecordProgress(),
        const SizedBox(height: IoCrosswordSpacing.xxlg),
        PrimaryButton(
          onPressed: () {
            context.read<GameIntroBloc>().add(const WelcomeCompleted());
          },
          label: l10n.getStarted,
        ),
      ],
    );
  }
}

class RecordProgress extends StatelessWidget {
  const RecordProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // TODO(any): Replace with real data
    const solvedWords = 50234;
    const totalWords = 100123;

    final f = NumberFormat.decimalPattern(l10n.localeName);

    return Column(
      children: [
        Text(
          l10n.wordsToBreakRecord,
          style: IoCrosswordTextStyles.bodyLG,
        ),
        const SizedBox(height: IoCrosswordSpacing.sm),
        LinearProgressIndicator(
          value: 0.5,
          minHeight: 4,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: IoCrosswordSpacing.sm),
        Text(
          '${f.format(solvedWords)} / ${f.format(totalWords)}',
          style: IoCrosswordTextStyles.bodyLG.medium,
        ),
      ],
    );
  }
}
