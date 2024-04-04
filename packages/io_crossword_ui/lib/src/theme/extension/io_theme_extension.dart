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
    required this.cardTheme,
    required this.physicalModel,
    required this.colorScheme,
  });

  /// {@macro io_player_alias_theme}
  final IoPlayerAliasTheme playerAliasTheme;

  /// {@macro io_icon_button_theme}
  final IoIconButtonTheme iconButtonTheme;

  /// {@macro io_card_theme}
  final IoCardTheme cardTheme;

  /// {@macro io_physical_model_style}
  final IoPhysicalModelStyle physicalModel;

  /// {@macro io_color_scheme}
  final IoColorScheme colorScheme;

  @override
  Object get type => IoThemeExtension;

  @override
  ThemeExtension<IoThemeExtension> copyWith({
    IoPlayerAliasTheme? playerAliasTheme,
    IoIconButtonTheme? iconButtonTheme,
    IoCardTheme? cardTheme,
    IoPhysicalModelStyle? physicalModel,
    IoColorScheme? colorScheme,
  }) {
    return IoThemeExtension(
      playerAliasTheme: playerAliasTheme ?? this.playerAliasTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      physicalModel: physicalModel ?? this.physicalModel,
      colorScheme: colorScheme ?? this.colorScheme,
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
      cardTheme: cardTheme.lerp(other.cardTheme, t),
      physicalModel: physicalModel.lerp(other.physicalModel, t),
      colorScheme: colorScheme.lerp(other.colorScheme, t),
    );
  }

  @override
  List<Object?> get props => [
        playerAliasTheme,
        iconButtonTheme,
        cardTheme,
        physicalModel,
        colorScheme,
      ];
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
