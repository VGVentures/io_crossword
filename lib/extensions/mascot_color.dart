import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

extension MascotColor on Mascot? {
  Color get color {
    return switch (this) {
      Mascot.dash => IoCrosswordColors.flutterBlue,
      Mascot.sparky => IoCrosswordColors.sparkyYellow,
      Mascot.dino => IoCrosswordColors.accessibleGrey,
      Mascot.android => IoCrosswordColors.androidGreen,
      null => IoCrosswordColors.flutterBlue,
    };
  }
}
