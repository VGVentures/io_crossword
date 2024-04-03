import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:io_crossword_ui/src/border/gradient_border.dart';

/// The Android team theme for IO Crossword.
class IoAndroidTheme extends IoCrosswordTheme {
  @override
  ColorScheme get colorScheme => super.colorScheme.copyWith(
        primary: IoCrosswordColors.seedGreen,
      );

  @override
  OutlinedButtonThemeData get outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: super.outlinedButtonThemeData.style!.copyWith(
              side: const MaterialStatePropertyAll(
                GradientBorder(
                  gradient: IoCrosswordColors.dashGradient,
                ),
              ),
            ),
      );
}
