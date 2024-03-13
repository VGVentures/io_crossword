// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

void main() {
  group('GameIntroEvent', () {
    group('WelcomeCompleted', () {
      test('supports value comparisons', () {
        expect(
          WelcomeCompleted(),
          equals(WelcomeCompleted()),
        );
      });
    });

    group('MascotSubmitted', () {
      test('supports value comparisons', () {
        expect(
          MascotSubmitted(),
          equals(MascotSubmitted()),
        );
      });
    });

    group('InitialsSubmitted', () {
      test('supports value comparisons', () {
        expect(
          InitialsSubmitted(),
          equals(InitialsSubmitted()),
        );
      });
    });
  });
}
