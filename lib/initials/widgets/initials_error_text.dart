import 'package:flutter/material.dart';

class InitialsErrorText extends StatelessWidget {
  const InitialsErrorText(
    this.data, {
    super.key,
  });

  final String data;

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
            text: data,
            style: TextStyle(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
