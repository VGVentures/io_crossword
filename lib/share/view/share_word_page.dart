import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ShareWordPage extends StatelessWidget {
  const ShareWordPage({required this.word, super.key});

  final Word word;

  static Future<void> showModal(BuildContext context, Word word) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;

        return ShareDialog(
          title: l10n.shareThisWord,
          content: ShareWordPage(
            word: word,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeData = Theme.of(context);

    return Column(
      children: [
        Text(
          l10n.shareWordTitle,
          textAlign: TextAlign.center,
          style: themeData.textTheme.bodySmall.regular,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        Text(
          l10n.shareWordSubtitle,
          textAlign: TextAlign.center,
          style: themeData.textTheme.bodySmall.regular,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        // TODO(any): Replace with the actual word from the
        // SelectedWordBloc:
        // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6443977120
        IoWord(
          '${word.answer.substring(0, 1)}_____',
          style: themeData.io.wordTheme.big,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        Text(
          word.clue,
          style: themeData.textTheme.bodySmall.regular
              ?.copyWith(color: themeData.colorScheme.primary),
        ),
      ],
    );
  }
}
