import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_chrome_theme}
/// The Chrome team theme for IO Crossword.
/// {@endtemplate}
abstract class IoChromeTheme {
  /// {@macro io_chrome_theme}
  static ThemeData get themeData {
    return IoCrosswordTheme.themeData.copyWith(
      primaryColor: IoCrosswordColors.seedGrey30,
    );
  }
}
