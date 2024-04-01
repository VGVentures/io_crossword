import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_flutter_theme}
/// The Flutter team theme for IO Crossword.
/// {@endtemplate}
abstract class IoFlutterTheme {
  /// {@macro io_flutter_theme}
  static ThemeData get themeData {
    return IoCrosswordTheme.themeData.copyWith(
      primaryColor: IoCrosswordColors.seedBlue,
    );
  }
}
