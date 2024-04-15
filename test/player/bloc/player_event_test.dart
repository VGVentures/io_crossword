// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
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
  });
}
