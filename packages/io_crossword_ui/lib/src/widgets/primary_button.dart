import 'package:flutter/material.dart';

/// {@template primary_button}
/// A primary button.
/// {@endtemplate}
class PrimaryButton extends StatelessWidget {
  /// {@macro primary_button}
  const PrimaryButton({
    required this.onPressed,
    required this.label,
    super.key,
  });

  /// The callback called when the button is tapped.
  final VoidCallback onPressed;

  /// The text to display in the button.
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
