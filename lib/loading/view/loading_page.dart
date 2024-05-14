import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/assets/assets.gen.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/loading/loading.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingView();
  }
}

class LoadingView extends StatelessWidget {
  @visibleForTesting
  const LoadingView({super.key});

  void _onLoaded(BuildContext context) {
    Navigator.of(context).push<void>(WelcomePage.route());
  }

  @override
  Widget build(BuildContext context) {
    final layout = IoLayout.of(context);

    return BlocListener<LoadingCubit, LoadingState>(
      listener: (context, state) {
        if (state.status == LoadingStatus.loaded) {
          _onLoaded(context);
        }
      },
      child: switch (layout) {
        IoLayoutData.small => const LoadingSmall(),
        IoLayoutData.large => const LoadingLarge(),
      },
    );
  }
}

class LoadingLarge extends StatelessWidget {
  @visibleForTesting
  const LoadingLarge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).io.textStyles;
    final l10n = context.l10n;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 294),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 32),
          Text(
            l10n.welcome,
            style: textTheme.heading1,
          ),
          const SizedBox(height: 32),
          Text(
            l10n.welcomeSubtitle,
            style: textTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          BlocBuilder<LoadingCubit, LoadingState>(
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
