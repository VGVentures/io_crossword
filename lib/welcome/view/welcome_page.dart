import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static Page<void> page() {
    return const MaterialPage(child: WelcomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        return switch (state.status) {
          LoadingStatus.loading => const LoadingPage(),
          LoadingStatus.loaded => const WelcomeView(),
        };
      },
    );
  }
}

class WelcomeView extends StatelessWidget {
  @visibleForTesting
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.small => const WelcomeSmall(),
      IoLayoutData.large => const WelcomeLarge(),
    };
  }
}

class WelcomeLarge extends StatelessWidget {
  @visibleForTesting
  const WelcomeLarge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        actions: (context) => const MuteButton(),
      ),
      body: SelectionArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.welcomeBackground.provider(),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: WelcomeBody(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeSmall extends StatelessWidget {
  @visibleForTesting
  const WelcomeSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        bottom: const WelcomeHeaderImage(),
        actions: (context) => const MuteButton(),
      ),
      body: const SelectionArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: WelcomeBody(),
          ),
        ),
      ),
    );
  }
}

class WelcomeBody extends StatelessWidget {
  @visibleForTesting
  const WelcomeBody({super.key});

  void _onGetStarted(BuildContext context) {
    GoRouter.of(context).go('/team');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 294),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const ChallengeProgressStatus(),
          const SizedBox(height: 48),
          OutlinedButton(
            onPressed: () => _onGetStarted(context),
            child: Text(l10n.getStarted),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
