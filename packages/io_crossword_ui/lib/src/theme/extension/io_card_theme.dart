import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_card_theme}
/// IO styles for [Card].
///
/// See also:
///
/// * [IoThemeExtension], which extends [ThemeData] with [IoIconButtonTheme].
/// {@endtemplate}
class IoCardTheme extends Equatable {
  /// {@macro io_card_theme}
  const IoCardTheme({
    required this.plain,
    required this.highlight,
  });

  /// The style for plain [Card].
  final CardTheme plain;

  /// The style for highlighted [Card].
  ///
  /// This is usually used for cards of higher importance.
  final CardTheme highlight;

  /// Linearly interpolate between two [IoCardTheme] themes.
  IoCardTheme lerp(IoCardTheme other, double t) {
    return IoCardTheme(
      plain: CardTheme.lerp(plain, other.plain, t),
      highlight: CardTheme.lerp(highlight, other.highlight, t),
    );
  }

  @override
  List<Object?> get props => [plain, highlight];
}
