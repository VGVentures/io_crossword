import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';

class InitialsSubmitButton extends StatelessWidget {
  const InitialsSubmitButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton(
      onPressed: onPressed,
      child: Text(l10n.enter),
    );
  }
}
