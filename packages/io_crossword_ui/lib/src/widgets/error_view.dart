import 'package:flutter/material.dart';

/// {@template error_view}
/// A widget used when there is an error.
///
/// If [buttonTitle] is not null the [OutlinedButton] is displayed.
/// {@endtemplate}
class ErrorView extends StatelessWidget {
  /// {@macro error_view}
  const ErrorView({
    required this.title,
    this.buttonTitle,
    this.onPressed,
    super.key,
  });

  /// Error message text.
  final String title;

  /// Button title used in [ElevatedButton] to retry.
  final String? buttonTitle;

  /// OnPressed to retry used in the [ElevatedButton].
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final buttonTitle = this.buttonTitle;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_rounded,
            size: 70,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          if (buttonTitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: OutlinedButton.icon(
                label: Text(buttonTitle),
                onPressed: onPressed,
                icon: const Icon(Icons.refresh),
              ),
            ),
        ],
      ),
    );
  }
}
