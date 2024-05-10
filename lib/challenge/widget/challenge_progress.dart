import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// Displays the collective progress of the words left to complete
/// the challenge.
///
/// The progress completes from left to right. Hence, right to left
/// directionality is not supported.
///
/// See also:
///
/// * [IoLinearProgressIndicator], which is used to display the progress.
class ChallengeProgress extends StatelessWidget {
  const ChallengeProgress({
    required this.solvedWords,
    required this.totalWords,
    super.key,
  });

  /// The amount of words solved.
  final int solvedWords;

  /// The total amount of words.
  ///
  /// Should be greater than 0. Otherwise, the progress will be 0.
  final int totalWords;

  @visibleForTesting
  static const solvedWordsKey = Key('ChallengeProgress_solvedWords');

  @visibleForTesting
  static const totalWordsKey = Key('ChallengeProgress_totalWords');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final formatter = NumberFormat.decimalPattern(l10n.localeName);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.countdownToCompletion,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: IoCrosswordSpacing.sm),
        IoLinearProgressIndicator(
          value: totalWords <= 0 ? 0 : solvedWords / totalWords,
        ),
        const SizedBox(height: IoCrosswordSpacing.sm),
        Row(
          // Forces the solved words to be display at the left and the total
          // words at the right, since the linear progress indicator always
          // displays the progress from left to right.
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key: solvedWordsKey,
              formatter.format(solvedWords),
              style: theme.textTheme.labelMedium,
            ),
            Text(
              key: totalWordsKey,
              formatter.format(totalWords),
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ],
    );
  }
}
