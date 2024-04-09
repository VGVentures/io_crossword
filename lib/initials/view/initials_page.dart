import 'package:api_client/api_client.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsPage extends StatelessWidget {
  const InitialsPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: InitialsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitialsBloc(
        leaderboardResource: context.read<LeaderboardResource>(),
      )..add(const InitialsBlocklistRequested()),
      child: const InitialsView(),
    );
  }
}

class InitialsView extends StatelessWidget {
  const InitialsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<InitialsBloc, InitialsState>(
      builder: (context, state) {
        switch (state.status) {
          case InitialsStatus.initial:
            return const _InitialsLoaded();
          case InitialsStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case InitialsStatus.success:
            return const _InitialsLoaded();
          case InitialsStatus.failure:
            return ErrorView(title: l10n.initialsSubmissionErrorMessage);
        }
      },
    );
  }
}

class _InitialsLoaded extends StatelessWidget {
  const _InitialsLoaded();

  void _onWord(BuildContext context, String word) {
    context.read<InitialsBloc>().add(InitialsChanged(word));
  }

  void _onSubmit(BuildContext context) {
    final initials = context.read<InitialsBloc>().state.initials;
    context.read<CrosswordBloc>().add(
          InitialsSelected(initials!.value.split('')),
        );

    context.flow<GameIntroState>().update(
          (state) => state.copyWith(
            isIntroCompleted: true,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    // if (state.initialsStatus == InitialsFormStatus.blacklisted)
    //   _ErrorTextWidget(l10n.initialsBlacklistedMessage)
    // else if (state.initialsStatus == InitialsFormStatus.invalid)
    //   _ErrorTextWidget(l10n.initialsErrorMessage)
    // else if (state.initialsStatus == InitialsFormStatus.failure)
    //   _ErrorTextWidget(l10n.initialsSubmissionErrorMessage),

    return Scaffold(
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
                    l10n.enterInitials,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 32),
                  IoWordInput.alphabetic(
                    length: 3,
                    onWord: (word) => _onWord(context, word),
                  ),
                  const SizedBox(height: 32),
                  InitialsSubmitButton(onPressed: () => _onSubmit(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
