import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_outline_button}
/// IO styles for [OutlinedButton].
///
/// See also:
///
/// * [IoThemeExtension], which extends [ThemeData] with [IoOutlineButtonTheme].
/// {@endtemplate}
class IoOutlineButtonTheme extends Equatable {
  /// {@macro io_outline_button}
  const IoOutlineButtonTheme({
    required this.simpleBorder,
  });

  /// The style for one color [OutlinedButton].
  final ButtonStyle simpleBorder;

  /// Linearly interpolate between two [IoOutlineButtonTheme] themes.
  IoOutlineButtonTheme lerp(IoOutlineButtonTheme other, double t) {
    return IoOutlineButtonTheme(
      simpleBorder: ButtonStyle.lerp(simpleBorder, other.simpleBorder, t)!,
    );
  }

  @override
  List<Object?> get props => [simpleBorder];
}
