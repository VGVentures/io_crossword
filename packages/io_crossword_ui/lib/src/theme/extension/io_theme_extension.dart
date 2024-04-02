import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

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
