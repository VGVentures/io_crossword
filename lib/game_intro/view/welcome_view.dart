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

    return CardScrollableContentWithButton(
      buttonLabel: l10n.getStarted,
      onPressed: () {
        context.read<GameIntroBloc>().add(const WelcomeCompleted());
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Placeholder(fallbackHeight: 150),
          const SizedBox(height: IoCrosswordSpacing.xlg),
          Text(
            l10n.welcome,
            style: IoCrosswordTextStyles.bodyLG,
          ),
          const SizedBox(height: IoCrosswordSpacing.sm),
          Text(
            l10n.welcomeSubtitle,
            style: IoCrosswordTextStyles.bodyLG,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          const RecordProgress(),
          const SizedBox(height: IoCrosswordSpacing.xxlg),
        ],
      ),
    );
  }
}

class RecordProgress extends StatelessWidget {
  @visibleForTesting
  const RecordProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final solvedWords =
        context.select((GameIntroBloc bloc) => bloc.state.solvedWords);
    final totalWords =
        context.select((GameIntroBloc bloc) => bloc.state.totalWords);

    final f = NumberFormat.decimalPattern(l10n.localeName);

    return Column(
      children: [
        Text(
          l10n.wordsToBreakRecord,
          style: IoCrosswordTextStyles.bodyLG,
        ),
        const SizedBox(height: IoCrosswordSpacing.sm),
        IoLinearProgressIndicator(
          value: totalWords == 0 ? 0 : solvedWords / totalWords,
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
