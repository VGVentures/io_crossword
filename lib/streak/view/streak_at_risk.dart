import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/streak/streak.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class StreakAtRiskView extends StatelessWidget {
  const StreakAtRiskView({super.key});

  @override
  Widget build(BuildContext context) {
    return IoPhysicalModel(
      child: Card(
        child: SizedBox(
          width: 340,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Expanded(child: _Title()),
                    CloseButton(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.streakAtRiskMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text(
                  context.l10n.continuationConfirmation,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const _BottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface;

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.warning_rounded,
              color: color,
              size: 20,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: l10n.streakAtRiskTitle,
            style: theme.textTheme.bodyLarge!.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  void _onLeave(BuildContext context) {} // coverage:ignore-line

  void _onSolveIt(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: LeaveButton(
            onPressed: () => _onLeave(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SolveItButton(
            onPressed: () => _onSolveIt(context),
          ),
        ),
      ],
    );
  }
}
