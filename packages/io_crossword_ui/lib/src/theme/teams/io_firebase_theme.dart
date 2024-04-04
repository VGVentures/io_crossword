import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// The Firebase team theme for IO Crossword.
class IoFirebaseTheme extends IoCrosswordTheme {
  @override
  ColorScheme get colorScheme => super.colorScheme.copyWith(
        primary: IoCrosswordColors.seedYellow,
      );

  @override
  IoColorScheme get ioColorScheme {
    return const IoColorScheme(
      primaryGradient: IoCrosswordColors.sparkyGradient,
    );
  }
}
