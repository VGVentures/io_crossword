import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_linear_progress_indicator}
/// Linear progress indicator using the [IoColorScheme.primaryGradient].
///
/// {@endtemplate}
class IoLinearProgressIndicator extends StatelessWidget {
  /// {@macro io_linear_progress_indicator}
  const IoLinearProgressIndicator({
    required this.value,
    super.key,
  });

  /// Used to indicate the percent of the progress to display.
  final double value;

  @override
  Widget build(BuildContext context) {
    final gradient = Theme.of(context)
        .extension<IoThemeExtension>()
        ?.colorScheme
        .primaryGradient;

    final linearTrackColor =
        Theme.of(context).progressIndicatorTheme.linearTrackColor;

    return Stack(
      children: [
        Align(
          child: SizedBox(
            width: double.infinity,
            height: 6,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: linearTrackColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 6,
            child: AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 350),
              widthFactor: value.clamp(0, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
