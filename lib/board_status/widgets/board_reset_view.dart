import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/board_status/board_status.dart';
import 'package:io_crossword/end_game/end_game.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class BoardResetView extends StatelessWidget {
  const BoardResetView({required this.onResume, super.key});

  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: const Color(0x88000000),
      child: Center(
        child: IoPhysicalModel(
          child: Card(
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      l10n.resetDialogTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.resetDialogSubtitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _ResetActions(onResume),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetActions extends StatelessWidget {
  const _ResetActions(
    this.onResume,
  );

  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<BoardStatusBloc, BoardStatusState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => EndGameCheck.openDialog(context),
                child: Text(l10n.exitButtonLabel),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed:
                    state is BoardStatusResetInProgress ? null : onResume,
                child: Text(l10n.keepPlayingButtonLabel),
              ),
            ),
          ],
        );
      },
    );
  }
}
