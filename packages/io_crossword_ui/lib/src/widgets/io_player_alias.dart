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
    return Semantics(
      label: alias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final char in alias.split(''))
            Padding(
              padding: style.margin,
              child: _CharacterBox(char, style: style),
            ),
        ],
      ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
      ),
      child: SizedBox.square(
        dimension: style.boxSize.width,
        child: Center(
          child: Text(
            data,
            style: style.textStyle,
          ),
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
    required this.boxSize,
  });

  /// The background color of each box that encloses a character.
  final Color backgroundColor;

  /// The border radius of each box that encloses a character.
  final BorderRadius borderRadius;

  /// The text style of each character.
  final TextStyle textStyle;

  /// The margin of each character.
  final EdgeInsets margin;

  /// The size of the box that encloses a character.
  final Size boxSize;

  /// Linearly interpolate between two [IoPlayerAliasStyle]s.
  IoPlayerAliasStyle lerp(IoPlayerAliasStyle other, double t) {
    return IoPlayerAliasStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      margin: EdgeInsets.lerp(margin, other.margin, t)!,
      boxSize: Size.lerp(boxSize, other.boxSize, t)!,
    );
  }

  /// Creates a copy of this [IoPlayerAliasStyle] but with the given fields
  /// replaced with the new values.
  IoPlayerAliasStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    EdgeInsets? margin,
    Size? boxSize,
  }) {
    return IoPlayerAliasStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      margin: margin ?? this.margin,
      boxSize: boxSize ?? this.boxSize,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        borderRadius,
        textStyle,
        margin,
        boxSize,
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
