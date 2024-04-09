import 'package:api_client/api_client.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/initials/widgets/initials_error_text.dart';
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

@visibleForTesting
class InitialsView extends StatefulWidget {
  const InitialsView({super.key});

  @override
  State<InitialsView> createState() => _InitialsViewState();
}

class _InitialsViewState extends State<InitialsView> {
  final _wordInputController = IoWordInputController();

  void _onSubmit(BuildContext context) {
    context.read<InitialsBloc>()
      ..add(const InitialsBlocklistRequested())
      ..add(InitialsSubmitted(_wordInputController.word));
  }

  void _onSuccess(BuildContext context, InitialsState state) {
    final initials = state.initials.value.split('');
    context.read<CrosswordBloc>().add(InitialsSelected(initials));
    context.flow<GameIntroState>().complete();
  }

  @override
  void dispose() {
    _wordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocListener<InitialsBloc, InitialsState>(
      listenWhen: (previous, current) => current.initials.isValid,
      listener: _onSuccess,
      child: Scaffold(
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
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 32),
                    IoWordInput.alphabetic(
                      length: 3,
                      controller: _wordInputController,
                      onSubmit: (_) => _onSubmit(context),
                    ),
                    SizedBox(
                      height: 64,
                      child: BlocSelector<InitialsBloc, InitialsState,
                          InitialsInputError?>(
                        selector: (state) => state.initials.error,
                        builder: (context, error) {
                          if (error == null) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: InitialsErrorText(
                              error.toLocalizedString(context),
                            ),
                          );
                        },
                      ),
                    ),
                    InitialsSubmitButton(
                      onPressed: () => _onSubmit(context),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on InitialsInputError {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case InitialsInputError.format:
        return context.l10n.initialsErrorMessage;
      case InitialsInputError.blocklisted:
        return context.l10n.initialsBlacklistedMessage;
      case InitialsInputError.processing:
        return context.l10n.initialsSubmissionErrorMessage;
    }
  }
}
