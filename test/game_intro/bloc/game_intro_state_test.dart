// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/game_intro.dart';

void main() {
  group('GameIntroState', () {
    test('supports value comparisons', () {
      expect(
        GameIntroState(),
        equals(GameIntroState()),
      );
    });

    group('copyWith', () {
      test('updates status', () {
        expect(
          GameIntroState().copyWith(status: GameIntroStatus.mascotSelection),
          equals(GameIntroState(status: GameIntroStatus.mascotSelection)),
        );
      });

      test('updates isIntroCompleted', () {
        expect(
          GameIntroState().copyWith(isIntroCompleted: true),
          equals(GameIntroState(isIntroCompleted: true)),
        );
      });
    });
  });
}
