import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

extension MascotColor on Mascots? {
  Color get color {
    return switch (this) {
      Mascots.dash => IoCrosswordColors.seedBlue,
      Mascots.sparky => IoCrosswordColors.seedYellow,
      Mascots.dino => IoCrosswordColors.accessibleGrey,
      Mascots.android => IoCrosswordColors.seedGreen,
      null => IoCrosswordColors.seedBlue,
    };
  }
}
