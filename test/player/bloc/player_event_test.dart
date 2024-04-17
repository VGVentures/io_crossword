// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';

void main() {
  group('$PlayerEvent', () {
    group('$PlayerLoaded', () {
      test('checks equality', () {
        expect(
          PlayerLoaded(userId: 'user-id'),
          equals(PlayerLoaded(userId: 'user-id')),
        );

        expect(
          PlayerLoaded(userId: 'user-id'),
          isNot(equals(PlayerLoaded(userId: 'user-id-1'))),
        );
      });
    });

    group('MascotSelected', () {
      test('can be instantiated', () {
        expect(MascotSelected(Mascots.sparky), isA<MascotSelected>());
      });

      test('supports value comparisons', () {
        expect(
          MascotSelected(Mascots.sparky),
          equals(MascotSelected(Mascots.sparky)),
        );
        expect(
          MascotSelected(Mascots.sparky),
          isNot(equals(MascotSelected(Mascots.dash))),
        );
      });
    });

    group('InitialsSelected', () {
      test('can be instantiated', () {
        expect(InitialsSelected('WOW'), isA<InitialsSelected>());
      });

      test('supports value comparisons', () {
        expect(
          InitialsSelected('WOW'),
          equals(InitialsSelected('WOW')),
        );
        expect(
          InitialsSelected('WOW'),
          isNot(equals(InitialsSelected('GGG'))),
        );
      });
    });
  });
}
