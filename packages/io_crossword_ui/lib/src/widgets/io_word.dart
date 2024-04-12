import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template io_word}
/// A widget that displays a word, with each character enclosed in a box.
/// {@endtemplate}
class IoWord extends StatelessWidget {
  /// {@macro io_word}
  const IoWord(
    this.data, {
    required this.style,
    super.key,
  });

  /// The word to display.
  final String data;

  /// {@macro io_word_style}
  final IoWordStyle style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: data,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final char in data.split(''))
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

  final IoWordStyle style;

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

/// {@template io_word_style}
/// The style configuration of a [IoWord].
/// {@endtemplate}
class IoWordStyle extends Equatable {
  /// {@macro io_word_style}
  const IoWordStyle({
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

  /// Linearly interpolate between two [IoWordStyle]s.
  IoWordStyle lerp(IoWordStyle other, double t) {
    return IoWordStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      margin: EdgeInsets.lerp(margin, other.margin, t)!,
      boxSize: Size.lerp(boxSize, other.boxSize, t)!,
    );
  }

  /// Creates a copy of this [IoWordStyle] but with the given fields
  /// replaced with the new values.
  IoWordStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    EdgeInsets? margin,
    Size? boxSize,
  }) {
    return IoWordStyle(
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

/// {@template io_word_theme}
/// Collection of a [IoWordStyle]s.
/// {@endtemplate}
class IoWordTheme extends Equatable {
  /// {@macro io_word_theme}
  const IoWordTheme({
    required this.small,
    required this.big,
  });

  /// A small [IoWordStyle].
  final IoWordStyle small;

  /// A medium [IoWordStyle].
  final IoWordStyle big;

  /// Linearly interpolate between two [IoWordTheme]s.
  IoWordTheme lerp(IoWordTheme other, double t) {
    return IoWordTheme(
      small: small.lerp(other.small, t),
      big: big.lerp(other.big, t),
    );
  }

  @override
  List<Object?> get props => [small, big];
}
