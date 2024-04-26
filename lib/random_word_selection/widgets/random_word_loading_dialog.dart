import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class RandomWordLoadingDialog extends StatelessWidget {
  const RandomWordLoadingDialog({super.key});

  static Future<void> openDialog(BuildContext context) {
    final bloc = context.read<RandomWordSelectionBloc>();
    return showDialog<void>(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: const RandomWordLoadingDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<RandomWordSelectionBloc, RandomWordSelectionState>(
      listenWhen: (previous, current) =>
          current.status != RandomWordSelectionStatus.loading ||
          current.status != RandomWordSelectionStatus.failure,
      listener: (context, state) => Navigator.pop(context),
      builder: (context, state) {
        final child = state.status == RandomWordSelectionStatus.loading
            ? const LoadingView()
            : ErrorView(
                title: l10n.findRandomWordError,
                buttonTitle: l10n.close,
                onPressed: () => Navigator.pop(context),
              );

        return Center(
          child: IoCrosswordCard(
            maxHeight: 400,
            child: child,
          ),
        );
      },
    );
  }
}

class LoadingView extends StatelessWidget {
  @visibleForTesting
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            l10n.findRandomWordLoadingText,
            style: theme.textTheme.labelMedium.bold,
          ),
        ],
      ),
    );
  }
}
