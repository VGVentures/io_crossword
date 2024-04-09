import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocProvider(
      create: (context) => WelcomeBloc(
        boardInfoRepository: context.read(),
      )..add(const WelcomeDataRequested()),
      child: const WelcomeView(),
    );
  }
}

class WelcomeView extends StatelessWidget {
  @visibleForTesting
  const WelcomeView({super.key});

  void _onGetStarted(BuildContext context) {
    context.flow<GameIntroState>().update(
          (status) => status.copyWith(
            status: GameIntroStatus.mascotSelection,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        title: const SizedBox(),
        crossword: l10n.crossword,
        alwaysShowLogo: true,
        bottom: const WelcomeHeaderImage(),
        actions: (context) {
          return Row(
            children: [
              IconButton(
                // TODO(Ayad): volume logic
                // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6417645325
                // coverage:ignore-line
                onPressed: () {},
                icon: const Icon(Icons.volume_off),
              ),
              const SizedBox(width: 7),
              IconButton(
                // TODO(Ayad): menu logic
                // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6373424146
                // coverage:ignore-line
                onPressed: () {},
                icon: const Icon(Icons.menu),
              ),
            ],
          );
        },
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
                  BlocSelector<WelcomeBloc, WelcomeState, (int, int)>(
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
