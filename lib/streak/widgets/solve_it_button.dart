import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';

class SolveItButton extends StatelessWidget {
  const SolveItButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit, size: 20),
      label: Text(l10n.solveIt),
    );
  }
}
