import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:meta/meta.dart';

/// {@template io_crossword_theme}
/// IO Crossword theme.
/// {@endtemplate}
class IoCrosswordTheme {
  /// {@macro io_crossword_theme}
  IoCrosswordTheme();

  /// [ThemeData] for IO Crossword.
  ThemeData get themeData {
    final ioExtension = IoThemeExtension(
      playerAliasTheme: _playerAliasTheme,
      iconButtonTheme: _iconButtonTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      tabBarTheme: _tabBarTheme,
      actionIconTheme: _actionIconThemeData,
      filledButtonTheme: _filledButtonThemeData,
      iconButtonTheme: IconButtonThemeData(
        style: ioExtension.iconButtonTheme.outlined,
      ),
      extensions: {ioExtension},
    );
  }

  IoPlayerAliasTheme get _playerAliasTheme {
    final colorScheme = this.colorScheme;

    // TODO(alestiago): Update text styles from new Design System when
    // available:
    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6371389285
    return IoPlayerAliasTheme(
      small: IoPlayerAliasStyle(
        backgroundColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(0.31),
        textStyle: const TextStyle(
          fontFamily: 'Google Sans',
          fontSize: 10.34,
          fontWeight: FontWeight.w700,
          height: 1,
          package: IoCrosswordTextStyles.package,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0.5),
        boxSize: const Size.square(20.16),
      ),
      big: IoPlayerAliasStyle(
        backgroundColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(0.61),
        textStyle: const TextStyle(
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
    return const IoIconButtonTheme(
      outlined: ButtonStyle(
        shape: MaterialStatePropertyAll<OutlinedBorder>(
          CircleBorder(side: BorderSide(color: IoCrosswordColors.mediumGray)),
        ),
        iconColor: MaterialStatePropertyAll<Color>(IoCrosswordColors.seedWhite),
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.transparent),
      ),
      filled: ButtonStyle(
        iconColor: MaterialStatePropertyAll<Color>(IoCrosswordColors.seedWhite),
        backgroundColor:
            MaterialStatePropertyAll<Color>(IoCrosswordColors.mediumGray),
      ),
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

  @internal
  // ignore: public_member_api_docs
  ColorScheme get colorScheme {
    return ColorScheme.fromSeed(
      seedColor: IoCrosswordColors.seedBlue,
      background: IoCrosswordColors.seedBlack,
      surface: IoCrosswordColors.seedWhite,
      surfaceTint: IoCrosswordColors.seedWhite,
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

  static TextTheme get _textTheme {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;

    return isMobile
        ? IoCrosswordTextStyles.mobile.textTheme
        : IoCrosswordTextStyles.desktop.textTheme;
  }
}

/// {@template io_theme_extension}
/// Extension for the IO theme.
/// {@endtemplate}
@immutable
class IoThemeExtension extends Equatable
    implements ThemeExtension<IoThemeExtension> {
  /// {@macro io_theme_extension}
  const IoThemeExtension({
    required this.playerAliasTheme,
    required this.iconButtonTheme,
  });

  /// {@macro io_player_alias_theme}
  final IoPlayerAliasTheme playerAliasTheme;

  /// {@macro io_icon_button_theme}
  final IoIconButtonTheme iconButtonTheme;

  @override
  Object get type => IoThemeExtension;

  @override
  ThemeExtension<IoThemeExtension> copyWith({
    IoPlayerAliasTheme? playerAliasTheme,
    IoIconButtonTheme? iconButtonTheme,
  }) {
    return IoThemeExtension(
      playerAliasTheme: playerAliasTheme ?? this.playerAliasTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
    );
  }

  @override
  ThemeExtension<IoThemeExtension> lerp(
    covariant ThemeExtension<IoThemeExtension>? other,
    double t,
  ) {
    if (other is! IoThemeExtension) {
      return this;
    }

    return IoThemeExtension(
      playerAliasTheme: playerAliasTheme.lerp(other.playerAliasTheme, t),
      iconButtonTheme: iconButtonTheme.lerp(other.iconButtonTheme, t),
    );
  }

  @override
  List<Object?> get props => [playerAliasTheme, iconButtonTheme];
}

/// {@template extended_theme_data}
/// Get the [IoThemeExtension] from the [ThemeData].
/// {@endtemplate}
extension ExtendedThemeData on ThemeData {
  /// {@macro extended_theme_data}
  IoThemeExtension get io {
    final extension = this.extension<IoThemeExtension>();
    assert(extension != null, '$IoThemeExtension not found in $ThemeData');
    return extension!;
  }
}
