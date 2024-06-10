// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';

void main() {
  group('$PlayerState', () {
    test('supports value comparisons', () {
      expect(
        PlayerState(rank: 4, status: PlayerStatus.failure),
        equals(PlayerState(rank: 4, status: PlayerStatus.failure)),
      );

      expect(
        PlayerState(status: PlayerStatus.failure),
        isNot(equals(PlayerState())),
      );

      expect(
        PlayerState(
          player: Player(
            id: '1',
            initials: 'AAA',
            score: 100,
            streak: 2,
            mascot: Mascot.dash,
          ),
        ),
        isNot(equals(PlayerState())),
      );

      expect(
        PlayerState(rank: 4),
        isNot(equals(PlayerState())),
      );
    });

    group('copyWith', () {
      test('updates status', () {
        expect(
          PlayerState().copyWith(status: PlayerStatus.playing),
          equals(PlayerState(status: PlayerStatus.playing)),
        );
      });

      test('updates status', () {
        expect(
          PlayerState().copyWith(rank: 5),
          equals(PlayerState(rank: 5)),
        );
      });

      test('returns an instance with new mascot', () {
        final state = PlayerState(
          rank: 20,
        );

        final newState = state.copyWith(mascot: Mascot.dino);
        expect(newState.mascot, equals(Mascot.dino));
      });

      test('returns an instance with new initials', () {
        final state = PlayerState(
          rank: 20,
        );

        final newState = state.copyWith(
          player: state.player.copyWith(
            initials: 'ABC',
          ),
        );
        expect(newState.player.initials, equals('ABC'));
      });

      test('updates players', () {
        expect(
          PlayerState().copyWith(
            player: Player(
              id: '1',
              initials: 'AAA',
              score: 100,
              streak: 2,
              mascot: Mascot.dash,
            ),
          ),
          equals(
            PlayerState(
              player: Player(
                id: '1',
                initials: 'AAA',
                score: 100,
                streak: 2,
                mascot: Mascot.dash,
              ),
            ),
          ),
        );
      });
    });
  });
}
