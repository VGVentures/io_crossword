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
      tabBarTheme: _tabBarTheme,
      dialogTheme: _dialogTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
    );
  }

  static ColorScheme get _colorScheme {
    return ColorScheme.fromSeed(
      seedColor: IoCrosswordColors.seedBlue,
      background: IoCrosswordColors.seedBlack,
    );
  }

  static TextTheme get _textTheme {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return isMobile
        ? IoCrosswordTextStyles.mobile.textTheme
        : IoCrosswordTextStyles.desktop.textTheme;
  }

  static TabBarTheme get _tabBarTheme {
    const yellow = IoCrosswordColors.seedYellow;
    const grey = IoCrosswordColors.seedGrey50;

    return const TabBarTheme(
      labelColor: yellow,
      indicatorColor: yellow,
      unselectedLabelColor: grey,
      dividerColor: grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: yellow),
      ),
    );
  }

  static DialogTheme get _dialogTheme {
    const black = IoCrosswordColors.seedBlack;

    return const DialogTheme(
      backgroundColor: black,
      surfaceTintColor: Colors.transparent,
    );
  }

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
    );
  }
}
