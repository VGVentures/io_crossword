import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/share/widgets/widgets.dart';
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
    final textTheme = Theme.of(context).textTheme;
    const style = IoPlayerAliasStyle(
      backgroundColor: IoCrosswordColors.seedWhite,
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: BorderRadius.all(Radius.circular(0.36)),
      margin: EdgeInsets.all(0.5),
      boxSize: Size.square(30),
    );

    return Column(
      children: [
        Text(
          l10n.shareWordTitle,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall.regular,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        Text(
          l10n.shareWordSubtitle,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall.regular,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        // TODO(any): Update with new IoWord widget
        IoPlayerAlias(
          '${word.answer.substring(0, 1)}______',
          style: style,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        Text(word.clue),
      ],
    );
  }
}
