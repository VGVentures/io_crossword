import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:io_crossword_ui/src/border/gradient_border.dart';

/// The Flutter team theme for IO Crossword.
class IoFlutterTheme extends IoCrosswordTheme {
  @override
  ColorScheme get colorScheme => super.colorScheme.copyWith(
        primary: IoCrosswordColors.seedBlue,
      );

  @override
  OutlinedButtonThemeData get outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: super.outlinedButtonThemeData.style!.copyWith(
              shape: const MaterialStatePropertyAll(
                GradientOutlinedBorder(
                  gradient: IoCrosswordColors.dashGradient,
                ),
              ),
            ),
      );
}
