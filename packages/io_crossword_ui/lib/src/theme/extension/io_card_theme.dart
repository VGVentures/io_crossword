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
    required this.plainAlternative,
    required this.highlight,
    required this.elevated,
  });

  /// The style for plain [Card].
  final CardTheme plain;

  /// An alternative style for plain [Card].
  ///
  /// With a different border color.
  final CardTheme plainAlternative;

  /// The style for highlighted [Card].
  ///
  /// This is usually used for cards of higher importance.
  final CardTheme highlight;

  /// The style for an elevated [Card].
  ///
  /// Elevated [Card]s are usually wrapped with the [IoPhysicalModel] widget,
  /// to give a sense of elevation.
  final CardTheme elevated;

  /// Linearly interpolate between two [IoCardTheme] themes.
  IoCardTheme lerp(IoCardTheme other, double t) {
    return IoCardTheme(
      plain: CardTheme.lerp(plain, other.plain, t),
      plainAlternative:
          CardTheme.lerp(plainAlternative, other.plainAlternative, t),
      highlight: CardTheme.lerp(highlight, other.highlight, t),
      elevated: CardTheme.lerp(elevated, other.elevated, t),
    );
  }

  @override
  List<Object?> get props => [plain, plainAlternative, highlight, elevated];
}
