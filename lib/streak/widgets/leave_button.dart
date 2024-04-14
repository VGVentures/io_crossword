import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Leave'),
    );
  }
}
