import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static Page<void> page() {
    return const MaterialPage(child: WelcomePage());
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomeView();
  }
}

class WelcomeView extends StatelessWidget {
  @visibleForTesting
  const WelcomeView({super.key});

  void _onGetStarted(BuildContext context) {
    context
        .flow<GameIntroStatus>()
        .update((status) => GameIntroStatus.teamSelection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        bottom: const WelcomeHeaderImage(),
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 294),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(
                    l10n.welcome,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.welcomeSubtitle,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  BlocSelector<ChallengeBloc, ChallengeState, (int, int)>(
                    selector: (state) => (state.solvedWords, state.totalWords),
                    builder: (context, words) {
                      return ChallengeProgress(
                        solvedWords: words.$1,
                        totalWords: words.$2,
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  OutlinedButton(
                    onPressed: () => _onGetStarted(context),
                    child: Text(
                      l10n.getStarted,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
