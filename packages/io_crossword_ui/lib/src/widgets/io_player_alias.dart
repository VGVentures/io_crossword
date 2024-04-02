import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template io_player_alias}
/// A widget that displays a player alias.
///
/// An alias is usually a three letter abbreviation of the player's name.
/// {@endtemplate}
class IoPlayerAlias extends StatelessWidget {
  /// {@macro io_player_alias}
  const IoPlayerAlias(
    this.alias, {
    required this.style,
    super.key,
  });

  /// The player alias.
  ///
  /// Usually a three letter abbreviation of its name.
  final String alias;

  /// {@macro io_player_alias_style}
  final IoPlayerAliasStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final char in alias.split(''))
          Padding(
            padding: style.margin,
            child: _CharacterBox(char, style: style),
          ),
      ],
    );
  }
}

/// A decorated box that represents a character.
class _CharacterBox extends StatelessWidget {
  const _CharacterBox(
    this.data, {
    required this.style,
  });

  /// The character to display.
  final String data;

  final IoPlayerAliasStyle style;

  @override
  Widget build(BuildContext context) {
    final textStyle = style.textStyle;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
      ),
      child: SizedBox.square(
        dimension: textStyle.fontSize! * 1.5,
        child: Center(
          child: Text(data),
        ),
      ),
    );
  }
}

/// {@template io_player_alias_style}
/// The style configuration of a [IoPlayerAlias].
/// {@endtemplate}
class IoPlayerAliasStyle extends Equatable {
  /// {@macro io_player_alias_style}
  const IoPlayerAliasStyle({
    required this.backgroundColor,
    required this.borderRadius,
    required this.textStyle,
    required this.margin,
  });

  /// The background color of each box that encloses a character.
  final Color backgroundColor;

  /// The border radius of each box that encloses a character.
  final BorderRadius borderRadius;

  /// The text style of each character.
  final TextStyle textStyle;

  /// The margin of each character.
  final EdgeInsets margin;

  /// Linearly interpolate between two [IoPlayerAliasStyle]s.
  IoPlayerAliasStyle lerp(IoPlayerAliasStyle other, double t) {
    return IoPlayerAliasStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      margin: EdgeInsets.lerp(margin, other.margin, t)!,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        borderRadius,
        textStyle,
        margin,
      ];
}

/// {@template io_player_alias_theme}
/// Collection of a [IoPlayerAliasStyle]s.
/// {@endtemplate}
class IoPlayerAliasTheme extends Equatable {
  /// {@macro io_player_alias_theme}
  const IoPlayerAliasTheme({
    required this.small,
    required this.big,
  });

  /// A small [IoPlayerAliasStyle].
  final IoPlayerAliasStyle small;

  /// A medium [IoPlayerAliasStyle].
  final IoPlayerAliasStyle big;

  /// Linearly interpolate between two [IoPlayerAliasTheme]s.
  IoPlayerAliasTheme lerp(IoPlayerAliasTheme other, double t) {
    return IoPlayerAliasTheme(
      small: small.lerp(other.small, t),
      big: big.lerp(other.big, t),
    );
  }

  @override
  List<Object?> get props => [small, big];
}
