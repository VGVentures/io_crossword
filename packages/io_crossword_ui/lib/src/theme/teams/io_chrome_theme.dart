import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// The Chrome team theme for IO Crossword.
class IoChromeTheme extends IoCrosswordTheme {
  @override
  ThemeData get themeData {
    return super.themeData.copyWith(
          primaryColor: IoCrosswordColors.seedGrey30,
        );
  }
}
