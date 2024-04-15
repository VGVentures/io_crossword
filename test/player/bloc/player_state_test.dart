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
          player: LeaderboardPlayer(
            userId: '1',
            initials: 'AAA',
            score: 100,
            streak: 2,
            mascot: Mascots.dash,
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

      test('updates players', () {
        expect(
          PlayerState().copyWith(
            player: LeaderboardPlayer(
              userId: '1',
              initials: 'AAA',
              score: 100,
              streak: 2,
              mascot: Mascots.dash,
            ),
          ),
          equals(
            PlayerState(
              player: LeaderboardPlayer(
                userId: '1',
                initials: 'AAA',
                score: 100,
                streak: 2,
                mascot: Mascots.dash,
              ),
            ),
          ),
        );
      });
    });
  });
}
