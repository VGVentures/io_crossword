import 'package:flutter/material.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsPage extends StatelessWidget {
  const InitialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const IoLayout(child: InitialsView());
  }
}

class InitialsView extends StatefulWidget {
  const InitialsView({super.key});

  @override
  State<InitialsView> createState() => _InitialsViewState();
}

class _InitialsViewState extends State<InitialsView> {
  /// The latest word that has been entered by the user.
  // TODO(alestiago): Consider using a IoWordController, once it is
  // available, see:
  // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6405677786
  // ignore: unused_field, use_late_for_private_fields_and_variables
  String? _word;

  // ignore: use_setters_to_change_properties
  void _onWord(String word) => _word = word;

  void _onSubmit() {
    // TODO(alestiago): Validate the initials and navigate to the next screen.
    // To be implemented once the following item is completed:
    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6398354276
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final layout = IoLayout.of(context);

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
                    style: switch (layout) {
                      IoLayoutData.small => theme.textTheme.bodyLarge,
                      IoLayoutData.large => theme.textTheme.headlineLarge,
                    },
                  ),
                  const SizedBox(height: 32),
                  IoWordInput.alphabetic(length: 3, onWord: _onWord),
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
