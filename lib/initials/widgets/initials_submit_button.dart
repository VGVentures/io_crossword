import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsSubmitButton extends StatelessWidget {
  const InitialsSubmitButton({
    required this.onPressed,
    required this.isLoading,
    super.key,
  });

  final VoidCallback onPressed;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final layout = IoLayout.of(context);

    final child = isLoading
        ? const CircularProgressIndicator()
        : Text(
            l10n.enter,
            style: switch (layout) {
              IoLayoutData.small => theme.textTheme.bodySmall,
              IoLayoutData.large => theme.textTheme.bodyMedium,
            },
          );

    return OutlinedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
