import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_crossword_theme}
/// IO Crossword theme.
/// {@endtemplate}
class IoCrosswordTheme {
  /// [ThemeData] for IO Crossword.
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: _textTheme.apply(
        bodyColor: IoCrosswordColors.seedWhite,
        displayColor: IoCrosswordColors.seedWhite,
        decorationColor: IoCrosswordColors.seedWhite,
      ),
    );
  }

  static ColorScheme get _colorScheme {
    return ColorScheme.fromSeed(
      seedColor: IoCrosswordColors.seedBlue,
      background: IoCrosswordColors.seedBlack,
      surface: IoCrosswordColors.seedWhite,
      surfaceTint: IoCrosswordColors.seedWhite,
    );
  }

  static TextTheme get _textTheme {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return isMobile
        ? IoCrosswordTextStyles.mobile.textTheme
        : IoCrosswordTextStyles.desktop.textTheme;
  }
}
