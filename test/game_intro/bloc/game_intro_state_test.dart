// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';

void main() {
  group('$GameIntroState', () {
    test('supports equality', () {
      expect(
        GameIntroState(status: GameIntroPlayerCreationStatus.failure),
        equals(GameIntroState(status: GameIntroPlayerCreationStatus.failure)),
      );

      expect(
        GameIntroState(status: GameIntroPlayerCreationStatus.success),
        isNot(
          equals(
            GameIntroState(
              status: GameIntroPlayerCreationStatus.failure,
            ),
          ),
        ),
      );
    });
  });
}
