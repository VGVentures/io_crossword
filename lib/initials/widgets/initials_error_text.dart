import 'package:flutter/material.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';

/// A [RichText] widget that displays an error icon and error text.
///
/// To display a meaningful error message whenever the user enters invalid
/// initials.
class InitialsErrorText extends StatelessWidget {
  const InitialsErrorText(
    this.error, {
    super.key,
  });

  /// The error message to display.
  final InitialsInputError error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 20,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: error.toLocalizedString(context),
            style: TextStyle(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

extension on InitialsInputError {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case InitialsInputError.format:
        return context.l10n.initialsErrorMessage;
      case InitialsInputError.blocklisted:
        return context.l10n.initialsBlacklistedMessage;
      case InitialsInputError.processing:
        return context.l10n.initialsSubmissionErrorMessage;
    }
  }
}
