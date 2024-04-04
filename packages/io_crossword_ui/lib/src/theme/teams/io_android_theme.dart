import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

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
          shape: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return const StadiumBorder(
                  side: BorderSide(
                    width: 2,
                  ),
                );
              }

              return const GradientStadiumBorder(
                gradient: IoCrosswordColors.androidGradient,
              );
            },
          ),
        ),
      );
}
