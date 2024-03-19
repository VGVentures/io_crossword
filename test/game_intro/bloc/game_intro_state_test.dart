// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
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

      test('updates solvedWords', () {
        expect(
          GameIntroState().copyWith(solvedWords: 987),
          equals(GameIntroState(solvedWords: 987)),
        );
      });

      test('updates totalWords', () {
        expect(
          GameIntroState().copyWith(totalWords: 1234),
          equals(GameIntroState(totalWords: 1234)),
        );
      });

      test('updates selectedMascot', () {
        expect(
          GameIntroState().copyWith(selectedMascot: Mascots.android),
          equals(GameIntroState(selectedMascot: Mascots.android)),
        );
      });

      test('updates initials', () {
        expect(
          GameIntroState().copyWith(initials: ['W', 'O', 'W']),
          equals(GameIntroState(initials: ['W', 'O', 'W'])),
        );
      });

      test('updates initialsStatus', () {
        expect(
          GameIntroState().copyWith(initialsStatus: InitialsFormStatus.success),
          equals(GameIntroState(initialsStatus: InitialsFormStatus.success)),
        );
      });
    });
  });
}
