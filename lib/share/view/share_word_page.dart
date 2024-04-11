import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ShareWordPage extends StatelessWidget {
  const ShareWordPage({required this.word, super.key});

  final Word word;

  static Future<void> showModal(BuildContext context, Word word) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return ShareWordPage(word: word);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const style = IoPlayerAliasStyle(
      backgroundColor: IoCrosswordColors.flutterBlue,
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      borderRadius: BorderRadius.all(Radius.circular(0.36)),
      margin: EdgeInsets.all(0.5),
      boxSize: Size.square(30),
    );

    return Center(
      child: IoCrosswordCard(
        maxWidth: 340,
        maxHeight: 598,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.ios_share,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.shareThisWord,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall.medium,
                  ),
                  const Expanded(child: SizedBox()),
                  const CloseButton(),
                ],
              ),
              const SizedBox(height: IoCrosswordSpacing.xlgsm),
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
              // TODO(any): Update with new IoWord widget
              IoPlayerAlias(
                '${word.answer.substring(0, 1)}______',
                style: style,
              ),
              const SizedBox(height: IoCrosswordSpacing.xlgsm),
              Text(word.clue),
              const SizedBox(height: IoCrosswordSpacing.xlgsm),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.linkedin),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.instagram),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.twitter),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Icon(IoIcons.facebook),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
