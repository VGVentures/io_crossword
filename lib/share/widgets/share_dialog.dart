import 'package:flutter/material.dart';
import 'package:io_crossword/extensions/context_ext.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ShareDialog extends StatelessWidget {
  const ShareDialog({
    required this.title,
    required this.content,
    required this.url,
    super.key,
  });

  final Widget content;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final iconButtonStyle = Theme.of(context).io.iconButtonTheme.flat;

    return Center(
      child: IoPhysicalModel(
        child: Card(
          child: SizedBox(
            width: 340,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 56,
                  top: 16,
                ),
                child: Column(
                  children: [
                    ShareDialogHeader(title: title),
                    const SizedBox(height: IoCrosswordSpacing.xlgsm),
                    content,
                    const SizedBox(height: IoCrosswordSpacing.xlg),
                    Text(
                      l10n.shareOn,
                    ),
                    const SizedBox(height: IoCrosswordSpacing.xlgsm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          style: iconButtonStyle,
                          onPressed: () {
                            context.shareLinkedIn(shareUrl: url);
                          },
                          icon: const Icon(IoIcons.linkedin),
                        ),
                        IconButton(
                          style: iconButtonStyle,
                          onPressed: () {
                            context.shareTwitter(shareUrl: url);
                          },
                          icon: const Icon(IoIcons.twitter),
                        ),
                        IconButton(
                          style: iconButtonStyle,
                          onPressed: () {
                            context.shareFacebook(shareUrl: url);
                          },
                          icon: const Icon(IoIcons.facebook),
                        ),
                      ],
                    ),
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
        const SizedBox(width: 30),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge.medium,
          ),
        ),
        const CloseButton(),
      ],
    );
  }
}
