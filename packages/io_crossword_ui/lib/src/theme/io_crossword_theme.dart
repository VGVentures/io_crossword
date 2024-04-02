import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_crossword_theme}
/// IO Crossword theme.
/// {@endtemplate}
abstract class IoCrosswordTheme {
  /// [ThemeData] for IO Crossword.
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      tabBarTheme: _tabBarTheme,
      actionIconTheme: _actionIconThemeData,
      filledButtonTheme: _filledButtonThemeData,
    );
  }

  static FilledButtonThemeData get _filledButtonThemeData {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: IoCrosswordTextStyles.bodyLG,
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  static ActionIconThemeData get _actionIconThemeData {
    return ActionIconThemeData(
      closeButtonIconBuilder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF838998),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(2),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        );
      },
    );
  }

  static TabBarTheme get _tabBarTheme {
    return TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF2E3233);
          }

          return const Color(0xFF45484F);
        },
      ),
    );
  }

  /// Gemini input decoration theme.
  static InputDecorationTheme get geminiInputDecorationTheme {
    const borderRadius = BorderRadius.all(Radius.circular(40));
    const borderSide = BorderSide(
      width: 2,
    );

    return InputDecorationTheme(
      outlineBorder: borderSide,
      hintStyle: _textTheme.bodyLarge?.copyWith(
        color: const Color(0xFF80858B),
        fontWeight: FontWeight.w400,
      ),
      border: const GradientInputBorder(
        gradient: IoCrosswordColors.geminiGradient,
        borderRadius: borderRadius,
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      enabledBorder: const GradientInputBorder(
        gradient: IoCrosswordColors.geminiGradient,
        borderRadius: borderRadius,
      ),
      focusedBorder: const GradientInputBorder(
        gradient: IoCrosswordColors.geminiGradient,
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          width: 1.5,
          color: IoCrosswordColors.redError,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          width: 2,
          color: IoCrosswordColors.redError,
        ),
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
