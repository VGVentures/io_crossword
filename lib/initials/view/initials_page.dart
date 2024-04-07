import 'package:flutter/material.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsPage extends StatelessWidget {
  const InitialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InitialsView();
  }
}

class InitialsView extends StatelessWidget {
  const InitialsView({super.key});

  void _onSubmit() {
    // TODO(alestiago): Validate the initials and navigate to the next screen.
    // To be implemented once the following item is completed:
    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6398354276
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 294),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Text(
                    l10n.enterInitials,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 32),
                  IoWordInput.alphabetic(length: 3),
                  const SizedBox(height: 32),
                  InitialsSubmitButton(onPressed: _onSubmit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
