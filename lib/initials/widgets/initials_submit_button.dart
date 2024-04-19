import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsSubmitButton extends StatelessWidget {
  const InitialsSubmitButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final layout = IoLayout.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      child: Text(
        l10n.enter,
        style: switch (layout) {
          IoLayoutData.small => theme.textTheme.bodySmall,
          IoLayoutData.large => theme.textTheme.bodyMedium,
        },
      ),
    );
  }
}
