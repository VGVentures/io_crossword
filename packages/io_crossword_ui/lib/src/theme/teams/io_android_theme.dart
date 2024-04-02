import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// The Android team theme for IO Crossword.
class IoAndroidTheme extends IoCrosswordTheme {
  @override
  ThemeData get themeData {
    return super.themeData.copyWith(
          primaryColor: IoCrosswordColors.seedGreen,
        );
  }
}
