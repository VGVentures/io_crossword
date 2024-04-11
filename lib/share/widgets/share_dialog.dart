import 'package:flutter/material.dart';
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
    return Center(
      child: IoCrosswordCard(
        maxWidth: 340,
        maxHeight: 540,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
          child: Column(
            children: [
              ShareDialogHeader(title: title),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: IoCrosswordSpacing.xlgsm,
                ),
                child: content,
              ),
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
        const Expanded(child: SizedBox()),
        const CloseButton(),
      ],
    );
  }
}
