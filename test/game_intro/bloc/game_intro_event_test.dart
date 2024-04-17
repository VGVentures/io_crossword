// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';

void main() {
  group('$GameIntroEvent', () {
    group('$GameIntroPlayerCreated', () {
      test('supports equality', () {
        expect(
          GameIntroPlayerCreated(mascot: Mascots.android, initials: 'ABC'),
          equals(
            GameIntroPlayerCreated(mascot: Mascots.android, initials: 'ABC'),
          ),
        );

        expect(
          GameIntroPlayerCreated(mascot: Mascots.android, initials: 'ABC'),
          isNot(
            equals(
              GameIntroPlayerCreated(mascot: Mascots.dash, initials: 'ABC'),
            ),
          ),
        );

        expect(
          GameIntroPlayerCreated(mascot: Mascots.android, initials: 'ABC'),
          isNot(
            equals(
              GameIntroPlayerCreated(mascot: Mascots.android, initials: 'CCC'),
            ),
          ),
        );
      });
    });
  });
}
