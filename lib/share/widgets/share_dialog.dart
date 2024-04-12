import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    required this.title,
    required this.content,
    super.key,
  });

  final Widget content;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: IoCrosswordCard(
        maxWidth: 340,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ShareDialogHeader(title: title),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: IoCrosswordSpacing.xlgsm,
                  ),
                  child: content,
                ),
                Text(
                  l10n.shareOn,
                ),
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
      ),
    );
  }
}

@visibleForTesting
class ShareDialogHeader extends StatelessWidget {
  @visibleForTesting
  const ShareDialogHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const Icon(
          Icons.ios_share,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall.medium,
        ),
        const Spacer(),
        const CloseButton(),
      ],
    );
  }
}
