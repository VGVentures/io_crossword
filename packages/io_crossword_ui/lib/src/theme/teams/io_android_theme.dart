import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// The Android team theme for IO Crossword.
class IoAndroidTheme extends IoCrosswordTheme {
  @override
  ColorScheme get colorScheme => super.colorScheme.copyWith(
        primary: IoCrosswordColors.androidGreen,
      );

  @override
  IoColorScheme get ioColorScheme {
    return const IoColorScheme(
      primaryGradient: IoCrosswordColors.androidGradient,
    );
  }
}
