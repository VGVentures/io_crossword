import 'package:flutter/material.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class EndGameCheck extends StatelessWidget {
  const EndGameCheck({super.key});

  static Future<void> openDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return const EndGameCheck();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: IoPhysicalModel(
        child: Card(
          child: SizedBox(
            width: 340,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Expanded(child: _Title()),
                      CloseButton(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.sureToEndGame,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: Text(l10n.endGame),
                    onPressed: () {
                      Navigator.pushReplacement(context, EndGamePage.route());
                    },
                  ),
                ],
              ),
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
            text: l10n.endingGame,
            style: theme.io.textStyles.h2.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
