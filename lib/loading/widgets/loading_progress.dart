import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// Displays the progress of assets being loaded into cache.
///
/// See also:
///
/// * [IoLinearProgressIndicator], which is used to display the progress.
class LoadingProgress extends StatelessWidget {
  const LoadingProgress({
    required this.progress,
    super.key,
  });

  /// The loading progress.
  final int progress;

  @visibleForTesting
  static const progressKey = Key('LoadingProgress_progress');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IoLinearProgressIndicator(
          value: progress.toDouble(),
        ),
        const SizedBox(height: IoCrosswordSpacing.sm),
        Text(
          key: progressKey,
          l10n.percentage(progress),
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
