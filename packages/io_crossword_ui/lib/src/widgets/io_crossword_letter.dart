import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_crossword_letter}
/// A widget that displays a single letter with in a crossword.
/// {@endtemplate}
class IoCrosswordLetter extends StatelessWidget {
  /// {@macro io_crossword_letter}
  const IoCrosswordLetter(
    this.data, {
    this.style,
    super.key,
  });

  /// The letter to display.
  final String? data;

  /// {@macro io_crossword_letter_style}
  ///
  /// If `null`, the inherited [IoCrosswordLetterTheme.empty] is used.
  final IoCrosswordLetterStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = this.style ?? Theme.of(context).io.crosswordLetterTheme.empty;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: style.border,
        color: style.backgroundColor,
      ),
      child: data == null
          ? null
          : Center(
              child: Text(
                data!,
                textAlign: TextAlign.center,
                style: style.textStyle,
              ),
            ),
    );
  }
}

/// {@template io_crossword_letter_style}
/// Style configuration for [IoCrosswordLetter].
/// {@endtemplate}
class IoCrosswordLetterStyle extends Equatable {
  /// {@macro io_crossword_letter_style}
  const IoCrosswordLetterStyle({
    required this.backgroundColor,
    required this.border,
    required this.textStyle,
  });

  /// The background color of the letter.
  final Color backgroundColor;

  /// The border of the letter.
  final Border border;

  /// The text style of the letter.
  final TextStyle textStyle;

  /// Linearly interpolate between two [IoCrosswordLetterStyle]s.
  IoCrosswordLetterStyle lerp(IoCrosswordLetterStyle other, double t) {
    return IoCrosswordLetterStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      border: Border.lerp(border, other.border, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        border,
        textStyle,
      ];
}

/// {@template io_crossword_letter_theme}
/// Theme configuration for [IoCrosswordLetter].
/// {@endtemplate}
class IoCrosswordLetterTheme extends Equatable {
  /// {@macro io_crossword_letter_theme}
  const IoCrosswordLetterTheme({
    required this.dash,
    required this.sparky,
    required this.android,
    required this.dino,
    required this.empty,
  });

  /// A dash styled crossword letter.
  final IoCrosswordLetterStyle dash;

  /// A sparky styled crossword letter.
  final IoCrosswordLetterStyle sparky;

  /// An android styled crossword letter.
  final IoCrosswordLetterStyle android;

  /// A dino styled crossword letter.
  final IoCrosswordLetterStyle dino;

  /// An empty styled crossword letter.
  final IoCrosswordLetterStyle empty;

  /// Linearly interpolate between two [IoCrosswordLetterTheme]s.
  IoCrosswordLetterTheme lerp(IoCrosswordLetterTheme other, double t) {
    return IoCrosswordLetterTheme(
      dash: dash.lerp(other.dash, t),
      sparky: sparky.lerp(other.sparky, t),
      android: android.lerp(other.android, t),
      dino: dino.lerp(other.dino, t),
      empty: empty.lerp(other.empty, t),
    );
  }

  @override
  List<Object?> get props => [dash, sparky, android, dino, empty];
}
