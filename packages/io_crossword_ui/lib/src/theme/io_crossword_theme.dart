import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:meta/meta.dart';

/// {@template io_crossword_theme}
/// IO Crossword theme.
/// {@endtemplate}
class IoCrosswordTheme {
  /// {@macro io_crossword_theme}
  const IoCrosswordTheme();

  /// [ThemeData] for IO Crossword.
  ThemeData get themeData {
    final ioExtension = IoThemeExtension(
      wordTheme: _wordTheme,
      iconButtonTheme: _iconButtonTheme,
      cardTheme: _cardTheme,
      physicalModel: _physicalModel,
      colorScheme: ioColorScheme,
      wordInput: _textInput,
      outlineButtonTheme: _ioOutlineButtonTheme,
      crosswordLetterTheme: _crosswordLetterTheme,
      textStyles: _textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      dialogBackgroundColor: colorScheme.surface,
      textTheme: _textTheme.textTheme,
      tabBarTheme: _tabBarTheme,
      cardColor: _cardTheme.plain.color,
      cardTheme: _cardTheme.plain,
      actionIconTheme: _actionIconThemeData,
      progressIndicatorTheme: _progressIndicatorTheme,
      filledButtonTheme: _filledButtonThemeData,
      outlinedButtonTheme: _outlinedButtonThemeData,
      segmentedButtonTheme: _segmentedButtonTheme,
      dividerTheme: _dividerTheme,
      iconButtonTheme: IconButtonThemeData(
        style: ioExtension.iconButtonTheme.outlined,
      ),
      extensions: {ioExtension},
    );
  }

  DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: IoCrosswordColors.mediumGray,
    );
  }

  IoWordInputTheme get _textInput {
    final colorScheme = this.colorScheme;

    final primaryWordInput = () {
      const textStyle = TextStyle(
        color: IoCrosswordColors.seedWhite,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Google Sans',
        package: IoCrosswordTextStyles.package,
      );
      const size = Size.square(48.61);
      const borderSide = BorderSide(
        width: 1.8,
        color: IoCrosswordColors.seedWhite,
      );

      return IoWordInputStyle(
        padding: const EdgeInsets.symmetric(horizontal: 1.8),
        empty: IoWordInputCharacterFieldStyle(
          backgroundColor: colorScheme.surface,
          border: Border.all(width: borderSide.width, color: borderSide.color),
          borderRadius: const BorderRadius.all(Radius.circular(0.77)),
          textStyle: textStyle,
          size: size,
        ),
        filled: IoWordInputCharacterFieldStyle(
          backgroundColor: colorScheme.primary,
          border:
              Border.all(width: borderSide.width, color: colorScheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(0.77)),
          textStyle: textStyle.copyWith(
            color: IoCrosswordColors.black,
          ),
          size: size,
        ),
        focused: IoWordInputCharacterFieldStyle(
          backgroundColor: colorScheme.surface,
          border: Border(
            top: borderSide,
            left: borderSide,
            right: borderSide,
            bottom: BorderSide(
              width: 10,
              color: borderSide.color,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          elevation: 10,
          size: size,
          borderRadius: const BorderRadius.all(Radius.circular(0.77)),
          textStyle: textStyle,
        ),
        disabled: IoWordInputCharacterFieldStyle(
          backgroundColor: IoCrosswordColors.seedWhite,
          border: Border.all(width: 0),
          borderRadius: const BorderRadius.all(Radius.circular(0.77)),
          textStyle: textStyle.copyWith(
            color: IoCrosswordColors.black,
          ),
          size: size,
        ),
      );
    }();

    final secondaryWordInput = () {
      final letterTheme = _crosswordLetterTheme;

      final textStyle = letterTheme.empty.textStyle;
      final borderSide = BorderSide(
        color: letterTheme.empty.backgroundColor,
        width: 1.74,
      );
      const size = Size.square(53);
      final backgroundColor = letterTheme.empty.backgroundColor;

      return IoWordInputStyle(
        padding: const EdgeInsets.all(1.4),
        empty: IoWordInputCharacterFieldStyle(
          backgroundColor: backgroundColor,
          border: Border.all(
            color: borderSide.color,
            width: borderSide.width,
          ),
          borderRadius: BorderRadius.zero,
          textStyle: textStyle,
          size: size,
        ),
        filled: IoWordInputCharacterFieldStyle(
          backgroundColor: colorScheme.primary,
          border: Border.all(
            color: colorScheme.primary,
            width: borderSide.width,
          ),
          borderRadius: BorderRadius.zero,
          textStyle: textStyle,
          size: size,
        ),
        focused: IoWordInputCharacterFieldStyle(
          backgroundColor: colorScheme.surface,
          border: Border(
            top: borderSide,
            left: borderSide,
            right: borderSide,
            bottom: BorderSide(
              width: 10,
              color: borderSide.color,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          elevation: 10,
          size: size,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0.1),
            topRight: Radius.circular(0.1),
          ),
          textStyle: textStyle.copyWith(color: backgroundColor),
        ),
        disabled: IoWordInputCharacterFieldStyle(
          backgroundColor: backgroundColor,
          border: Border.all(
            color: borderSide.color,
            width: borderSide.width,
          ),
          borderRadius: BorderRadius.zero,
          textStyle: textStyle,
          size: size,
        ),
      );
    }();

    return IoWordInputTheme(
      primary: primaryWordInput,
      secondary: secondaryWordInput,
    );
  }

  SegmentedButtonThemeData get _segmentedButtonTheme {
    return SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        side: const BorderSide(
          color: IoCrosswordColors.mediumGray,
        ),
      ).copyWith(
        iconColor: WidgetStatePropertyAll(
          colorScheme.primary,
        ),
      ),
    );
  }

  ProgressIndicatorThemeData get _progressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      linearTrackColor: IoCrosswordColors.mediumGray,
    );
  }

  @internal
  // ignore: public_member_api_docs
  IoColorScheme get ioColorScheme {
    return const IoColorScheme(
      primaryGradient: IoCrosswordColors.googleGradient,
    );
  }

  IoPhysicalModelStyle get _physicalModel {
    final ioColorScheme = this.ioColorScheme;

    return IoPhysicalModelStyle(
      gradient: ioColorScheme.primaryGradient,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      border: Border.all(color: IoCrosswordColors.black),
      elevation: 4,
    );
  }

  IoCardTheme get _cardTheme {
    final colorScheme = this.colorScheme;

    return IoCardTheme(
      plain: CardTheme(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: IoCrosswordColors.mediumGray),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        elevation: 0,
        color: colorScheme.surface,
      ),
      highlight: const CardTheme(
        margin: EdgeInsets.zero,
        shape: GradientInputBorder(
          gradient: IoCrosswordColors.googleGradient,
        ),
        elevation: 0,
        color: IoCrosswordColors.black,
      ),
      elevated: CardTheme(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: IoCrosswordColors.black),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        elevation: 0,
        color: colorScheme.surface,
      ),
    );
  }

  OutlinedButtonThemeData get _outlinedButtonThemeData {
    final ioColorScheme = this.ioColorScheme;
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(162, 64),
        backgroundColor: IoCrosswordColors.darkGray,
        foregroundColor: IoCrosswordColors.seedWhite,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        textStyle: _textTheme.body2,
      ).copyWith(
        shape: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return const StadiumBorder(side: BorderSide(width: 2));
            }
            return GradientStadiumBorder(
              gradient: ioColorScheme.primaryGradient,
            );
          },
        ),
      ),
    );
  }

  /// Gemini outlined button theme data
  static OutlinedButtonThemeData get geminiOutlinedButtonThemeData {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: IoCrosswordColors.seedWhite,
        padding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 18,
        ),
      ).copyWith(
        shape: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return const StadiumBorder(
                side: BorderSide(
                  width: 2,
                ),
              );
            }

            return const GradientStadiumBorder(
              gradient: IoCrosswordColors.geminiGradient,
            );
          },
        ),
      ),
    );
  }

  IoOutlineButtonTheme get _ioOutlineButtonTheme {
    return IoOutlineButtonTheme(
      googleBorder: _outlinedButtonThemeData.style!.copyWith(
        shape: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return const StadiumBorder(side: BorderSide(width: 2));
            }

            return const GradientStadiumBorder(
              gradient: IoCrosswordColors.googleGradient,
            );
          },
        ),
      ),
      simpleBorder: OutlinedButton.styleFrom(
        minimumSize: const Size(168, 56),
        foregroundColor: IoCrosswordColors.seedWhite,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ).copyWith(
        shape: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return const StadiumBorder(side: BorderSide(width: 2));
            }

            return const StadiumBorder(
              side: BorderSide(
                width: 2,
                color: IoCrosswordColors.mediumGray,
              ),
            );
          },
        ),
      ),
    );
  }

  IoWordTheme get _wordTheme {
    final colorScheme = this.colorScheme;

    return IoWordTheme(
      small: IoWordStyle(
        backgroundColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(0.31),
        textStyle: const TextStyle(
          color: IoCrosswordColors.black,
          fontFamily: 'Google Sans',
          fontSize: 10.34,
          fontWeight: FontWeight.w700,
          height: 1,
          package: IoCrosswordTextStyles.package,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0.5),
        boxSize: const Size.square(20.16),
      ),
      big: IoWordStyle(
        backgroundColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(0.61),
        textStyle: const TextStyle(
          color: IoCrosswordColors.black,
          fontFamily: 'Google Sans',
          fontSize: 14.61,
          fontWeight: FontWeight.w700,
          height: 1,
          package: IoCrosswordTextStyles.package,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 1.2),
        boxSize: const Size.square(40.12),
      ),
    );
  }

  IoIconButtonTheme get _iconButtonTheme {
    return IoIconButtonTheme(
      flat: ButtonStyle(
        iconSize: const WidgetStatePropertyAll<double>(20),
        side: const WidgetStatePropertyAll<BorderSide>(BorderSide.none),
        iconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return IoCrosswordColors.mediumGray;
          }
          return IoCrosswordColors.seedWhite;
        }),
        backgroundColor:
            const WidgetStatePropertyAll<Color>(Colors.transparent),
      ),
      outlined: ButtonStyle(
        iconSize: const WidgetStatePropertyAll<double>(20),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          CircleBorder(side: BorderSide(color: IoCrosswordColors.mediumGray)),
        ),
        iconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return IoCrosswordColors.mediumGray;
          }
          return IoCrosswordColors.seedWhite;
        }),
        backgroundColor:
            const WidgetStatePropertyAll<Color>(Colors.transparent),
      ),
      filled: ButtonStyle(
        iconSize: const WidgetStatePropertyAll<double>(20),
        iconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return IoCrosswordColors.mediumGray;
          }
          return IoCrosswordColors.seedWhite;
        }),
        backgroundColor:
            const WidgetStatePropertyAll<Color>(IoCrosswordColors.mediumGray),
      ),
    );
  }

  IoCrosswordLetterTheme get _crosswordLetterTheme {
    final textTheme = _textTheme;
    final colorScheme = this.colorScheme;

    final border = Border.all(color: colorScheme.surface);
    final textStyle = textTheme.h2.copyWith(
      color: colorScheme.surface,
      height: 1.1,
    );

    return IoCrosswordLetterTheme(
      dash: IoCrosswordLetterStyle(
        backgroundColor: IoCrosswordColors.flutterBlue,
        border: border,
        textStyle: textStyle,
      ),
      sparky: IoCrosswordLetterStyle(
        backgroundColor: IoCrosswordColors.sparkyYellow,
        border: border,
        textStyle: textStyle,
      ),
      android: IoCrosswordLetterStyle(
        backgroundColor: IoCrosswordColors.androidGreen,
        border: border,
        textStyle: textStyle,
      ),
      dino: IoCrosswordLetterStyle(
        backgroundColor: IoCrosswordColors.chromeRed,
        border: border,
        textStyle: textStyle,
      ),
      empty: IoCrosswordLetterStyle(
        backgroundColor: IoCrosswordColors.seedWhite,
        border: border,
        textStyle: textStyle,
      ),
    );
  }

  static FilledButtonThemeData get _filledButtonThemeData {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: _textTheme.body2,
        minimumSize: const Size(140, 56),
        backgroundColor: const Color(0XFF393B40),
        foregroundColor: Colors.white,
      ),
    );
  }

  static ActionIconThemeData get _actionIconThemeData {
    return ActionIconThemeData(
      closeButtonIconBuilder: (context) {
        return const Icon(
          Icons.close,
          color: Colors.white,
        );
      },
    );
  }

  static TabBarTheme get _tabBarTheme {
    return TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF2E3233);
          }

          return const Color(0xFF45484F);
        },
      ),
    );
  }

  @internal
  // ignore: public_member_api_docs
  ColorScheme get colorScheme {
    return ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: IoCrosswordColors.googleBlue,
      surface: IoCrosswordColors.darkGray,
      onSurface: IoCrosswordColors.seedWhite,
      surfaceTint: IoCrosswordColors.seedWhite,
      primary: IoCrosswordColors.googleBlue,
    );
  }

  /// Gemini input decoration theme.
  static InputDecorationTheme get geminiInputDecorationTheme {
    const borderRadius = BorderRadius.all(Radius.circular(40));
    const borderSide = BorderSide(width: 2);

    return InputDecorationTheme(
      outlineBorder: borderSide,
      hintStyle: _textTheme.body.copyWith(
        color: const Color(0xFF80858B),
        fontWeight: FontWeight.w400,
      ),
      border: const GradientInputBorder(
        gradient: IoCrosswordColors.geminiGradient,
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      enabledBorder: const GradientInputBorder(
        gradient: IoCrosswordColors.geminiGradient,
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      focusedBorder: const GradientInputBorder(
        gradient: IoCrosswordColors.geminiGradient,
        borderRadius: borderRadius,
        borderSide: borderSide,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          width: borderSide.width,
          color: IoCrosswordColors.redError,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          width: borderSide.width,
          color: IoCrosswordColors.redError,
        ),
      ),
    );
  }

  static IoCrosswordTextStyles get _textTheme {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return isMobile
        ? IoCrosswordTextStyles.mobile
        : IoCrosswordTextStyles.desktop;
  }
}
