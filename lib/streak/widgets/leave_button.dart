import 'package:flutter/material.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Leave'),
    );
  }
}
