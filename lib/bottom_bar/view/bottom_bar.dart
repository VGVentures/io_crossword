import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedWord = context.select(
      (CrosswordBloc bloc) => bloc.state.selectedWord,
    );

    if (selectedWord != null) {
      return const SizedBox.shrink();
    }

    return const BottomBarContent();
  }
}

class BottomBarContent extends StatelessWidget {
  @visibleForTesting
  const BottomBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final layout = IoLayout.of(context);
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        color: IoCrosswordColors.darkGray,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () {}, // coverage:ignore-line
              child: Text(
                l10n.submitScore,
                style: switch (layout) {
                  IoLayoutData.small => theme.textTheme.bodySmall,
                  IoLayoutData.large => theme.textTheme.bodyMedium,
                },
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {}, // coverage:ignore-line
              icon: const Icon(Icons.location_searching),
              label: Text(l10n.findNewWord),
            ),
          ],
        ),
      ),
    );
  }
}
