import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_icon_button_theme}
/// IO styles for [IconButton].
///
/// See also:
///
/// * [IoThemeExtension], which extends [ThemeData] with [IoIconButtonTheme].
/// {@endtemplate}
class IoIconButtonTheme extends Equatable {
  /// {@macro io_icon_button_theme}
  const IoIconButtonTheme({
    required this.flat,
    required this.outlined,
    required this.filled,
  });

  /// The style for flat [IconButton].
  final ButtonStyle flat;

  /// The style for outlined [IconButton].
  final ButtonStyle outlined;

  /// The style for filled [IconButton].
  ///
  /// Usually used on cards and modals.
  final ButtonStyle filled;

  /// Linearly interpolate between two [IoIconButtonTheme] themes.
  IoIconButtonTheme lerp(IoIconButtonTheme other, double t) {
    return IoIconButtonTheme(
      flat: ButtonStyle.lerp(flat, other.flat, t)!,
      outlined: ButtonStyle.lerp(outlined, other.outlined, t)!,
      filled: ButtonStyle.lerp(filled, other.filled, t)!,
    );
  }

  @override
  List<Object?> get props => [outlined, filled];
}
