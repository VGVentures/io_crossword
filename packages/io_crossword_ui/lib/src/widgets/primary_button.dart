import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

// TODO(Ayad): delete because we can use [FilledButton] with theme update

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
  final void Function()? onPressed;

  /// The text to display in the button.
  final String label;

  /// The default height of the [PrimaryButton].
  static const defaultHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: defaultHeight,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: IoCrosswordTextStyles.bodyLG,
        ),
      ),
    );
  }
}
