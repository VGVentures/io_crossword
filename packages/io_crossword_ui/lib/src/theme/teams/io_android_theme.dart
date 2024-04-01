import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_android_theme}
/// The Android team theme for IO Crossword.
/// {@endtemplate}
abstract class IoAndroidTheme {
  /// {@macro io_android_theme}
  static ThemeData get themeData {
    return IoCrosswordTheme.themeData.copyWith(
      primaryColor: IoCrosswordColors.seedGreen,
    );
  }
}
