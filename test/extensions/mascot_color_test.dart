// ignore_for_file: prefer_const_declarations

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('MascotColor', () {
    test('returns seedBlue for dash', () {
      expect(Mascots.dash.color, IoCrosswordColors.seedBlue);
    });

    test('returns seedYellow for sparky', () {
      expect(Mascots.sparky.color, IoCrosswordColors.seedYellow);
    });

    test('returns accessibleGrey for dino', () {
      expect(Mascots.dino.color, IoCrosswordColors.accessibleGrey);
    });

    test('returns seedGreen for android', () {
      expect(Mascots.android.color, IoCrosswordColors.seedGreen);
    });

    test('returns seedBlue when the mascot is not defined', () {
      final Mascots? nullMascot = null;
      expect(nullMascot.color, IoCrosswordColors.seedBlue);
    });
  });
}
