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
    context.read<InitialsBloc>().add(
          InitialsSubmitted(_wordInputController.word),
        );
  }

  void _onSuccess(BuildContext context, InitialsState state) {
    final initials = state.initials.value.split('');

    context.read<CrosswordBloc>().add(InitialsSelected(initials));

    context.flow<GameIntroState>().update(
          (state) => state.copyWith(
            isIntroCompleted: true,
          ),
        );
  }

  /// Returns the error message to display, if any.
  String? _displayError(BuildContext context) {
    final state = context.read<InitialsBloc>().state;
    final initials = state.initials;

    if (state.status != InitialsStatus.failure) return null;

    switch (initials.validator(initials.value)) {
      case InitialsInputError.format:
        return context.l10n.initialsErrorMessage;
      case InitialsInputError.blocklisted:
        return context.l10n.initialsBlacklistedMessage;
      case InitialsInputError.processing:
        return context.l10n.initialsSubmissionErrorMessage;
      case null:
        return context.l10n.initialsSubmissionErrorMessage;
    }
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
      listenWhen: (previous, current) =>
          current.status == InitialsStatus.success,
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
                    ),
                    SizedBox(
                      height: 64,
                      child: BlocBuilder<InitialsBloc, InitialsState>(
                        buildWhen: (previous, current) {
                          return previous.status != current.status &&
                              (current.status == InitialsStatus.failure ||
                                  previous.status == InitialsStatus.failure);
                        },
                        builder: (context, state) {
                          final displayError = _displayError(context);
                          return displayError != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: InitialsErrorText(displayError),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    BlocBuilder<InitialsBloc, InitialsState>(
                      buildWhen: (previous, current) {
                        return previous.status != current.status &&
                            (current.status == InitialsStatus.loading ||
                                previous.status == InitialsStatus.loading);
                      },
                      builder: (context, state) {
                        return InitialsSubmitButton(
                          isLoading: state.status == InitialsStatus.loading,
                          onPressed: () => _onSubmit(context),
                        );
                      },
                    ),
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
