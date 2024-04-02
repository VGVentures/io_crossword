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
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      tabBarTheme: _tabBarTheme,
      actionIconTheme: _actionIconThemeData,
      filledButtonTheme: _filledButtonThemeData,
      extensions: {
        IoThemeExtension(playerAliasTheme: _playerAliasTheme),
      },
    );
  }

  IoPlayerAliasTheme get _playerAliasTheme {
    final colorScheme = this.colorScheme;

    // TODO(alestiago): Update text styles from new Design System when available:
    // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6371389285
    return IoPlayerAliasTheme(
      small: IoPlayerAliasStyle(
        backgroundColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(0.31),
        textStyle: IoCrosswordTextStyles.displaySM,
        margin: const EdgeInsets.symmetric(horizontal: 0.5),
      ),
      big: IoPlayerAliasStyle(
        backgroundColor: colorScheme.primary,
        borderRadius: BorderRadius.circular(0.61),
        textStyle: IoCrosswordTextStyles.displayMD,
        margin: const EdgeInsets.symmetric(horizontal: 1.2),
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
  });

  /// The closest [IoThemeExtension] instance given the [context].
  static IoThemeExtension of(BuildContext context) {
    final theme = Theme.of(context);
    final extension = theme.extension<IoThemeExtension>();
    assert(extension != null, 'No IoThemeExtension found in the theme');
    return extension!;
  }

  /// {@macro io_player_alias_theme}
  final IoPlayerAliasTheme playerAliasTheme;

  @override
  Object get type => IoThemeExtension;

  @override
  ThemeExtension<IoThemeExtension> copyWith({
    IoPlayerAliasTheme? playerAliasTheme,
  }) {
    return IoThemeExtension(
      playerAliasTheme: playerAliasTheme ?? this.playerAliasTheme,
    );
  }

  @override
  ThemeExtension<IoThemeExtension> lerp(
    covariant ThemeExtension<IoThemeExtension>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }

    if (other is! IoThemeExtension) {
      return this;
    }

    return IoThemeExtension(
      playerAliasTheme: playerAliasTheme.lerp(other.playerAliasTheme, t),
    );
  }

  @override
  List<Object?> get props => [playerAliasTheme];
}
