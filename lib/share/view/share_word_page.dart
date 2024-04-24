import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        final shareResource = context.read<ShareResource>();

        return ShareDialog(
          title: l10n.shareThisWord,
          content: ShareWordPage(
            word: word,
          ),
          facebookShareUrl: shareResource.facebookShareBaseUrl(),
          linkedInShareUrl: shareResource.linkedinShareBaseUrl(),
          twitterShareUrl: shareResource.twitterShareBaseUrl(),
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
          '_' * word.length,
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
