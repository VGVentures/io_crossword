import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_firebase_theme}
/// The Firebase team theme for IO Crossword.
/// {@endtemplate}
abstract class IoFirebaseTheme {
  /// {@macro io_firebase_theme}
  static ThemeData get themeData {
    return IoCrosswordTheme.themeData.copyWith(
      primaryColor: IoCrosswordColors.seedYellow,
    );
  }
}
