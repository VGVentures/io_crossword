import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/project_details/project_details.dart';
import 'package:io_crossword/share/share.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class ShareWordPage extends StatelessWidget {
  const ShareWordPage({required this.word, super.key});

  final Word word;

  static Future<void> showModal(BuildContext context) async {
    final word = context.read<WordSelectionBloc>().state.word;
    final l10n = context.l10n;

    // If there are no words selected will display error message.
    if (word == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.errorPromptText),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    return showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;

        return ShareDialog(
          title: l10n.shareThisWord,
          content: ShareWordPage(
            word: word.word,
          ),
          url: ProjectDetailsLinks.crossword,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          l10n.shareWordTitle,
          textAlign: TextAlign.center,
          style: themeData.io.textStyles.body,
        ),
        const SizedBox(height: IoCrosswordSpacing.xlgsm),
        Text(
          l10n.shareWordSubtitle,
          textAlign: TextAlign.center,
          style: themeData.io.textStyles.body,
        ),
        const SizedBox(height: IoCrosswordSpacing.xxlg),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IoWord(
            word.answer.replaceAll(' ', '_'),
            style: themeData.io.wordTheme.big,
          ),
        ),
        const SizedBox(height: IoCrosswordSpacing.xlg),
        Text(
          word.clue,
          style: themeData.io.textStyles.body
              .copyWith(color: themeData.colorScheme.primary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
