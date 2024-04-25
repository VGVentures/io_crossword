import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  static Page<void> page() {
    return const MaterialPage(child: LoadingPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoadingCubit()..load(),
      child: const LoadingView(),
    );
  }
}

class LoadingView extends StatelessWidget {
  @visibleForTesting
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return switch (layout) {
      IoLayoutData.small => const LoadingSmall(),
      IoLayoutData.large => const LoadingLarge(),
    };
  }
}

class LoadingLarge extends StatelessWidget {
  @visibleForTesting
  const LoadingLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IoAppBar(
        logo: Assets.icons.crosswordLogo.image(),
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
                  child: LoadingBody(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingSmall extends StatelessWidget {
  @visibleForTesting
  const LoadingSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IoAppBar(
        logo: Assets.icons.crosswordLogo.image(),
        bottom: const WelcomeHeaderImage(),
      ),
      body: const SelectionArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: LoadingBody(),
          ),
        ),
      ),
    );
  }
}

class LoadingBody extends StatelessWidget {
  @visibleForTesting
  const LoadingBody({super.key});

  void _onGetStarted(BuildContext context) {
    context.flow<GameIntroStatus>().update((status) => GameIntroStatus.welcome);
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
          BlocConsumer<LoadingCubit, LoadingState>(
            listener: (context, state) {
              if (state.progress == 100) {
                _onGetStarted(context);
              }
            },
            builder: (context, state) {
              return LoadingProgress(
                progress: state.progress,
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
