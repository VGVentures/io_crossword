import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/welcome/welcome.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeView();
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Text('IO Crossword'),
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
                  const ChallengeProgress(
                    solvedWords: 25,
                    totalWords: 100,
                  ),
                  const SizedBox(height: 48),
                  OutlinedButton(
                    onPressed: () {},
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
