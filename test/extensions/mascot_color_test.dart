// ignore_for_file: prefer_const_declarations

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/extensions/extensions.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('MascotColor', () {
    test('returns seedBlue for dash', () {
      expect(Mascot.dash.color, IoCrosswordColors.flutterBlue);
    });

    test('returns seedYellow for sparky', () {
      expect(Mascot.sparky.color, IoCrosswordColors.sparkyYellow);
    });

    test('returns accessibleGrey for dino', () {
      expect(Mascot.dino.color, IoCrosswordColors.accessibleGrey);
    });

    test('returns seedGreen for android', () {
      expect(Mascot.android.color, IoCrosswordColors.androidGreen);
    });

    test('returns seedBlue when the mascot is not defined', () {
      final Mascot? nullMascot = null;
      expect(nullMascot.color, IoCrosswordColors.flutterBlue);
    });
  });
}
