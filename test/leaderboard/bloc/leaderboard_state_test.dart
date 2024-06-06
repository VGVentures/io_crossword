// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';

void main() {
  group('$LeaderboardState', () {
    test('supports value comparisons', () {
      expect(LeaderboardState(), equals(LeaderboardState()));

      expect(
        LeaderboardState(status: LeaderboardStatus.failure),
        isNot(equals(LeaderboardState())),
      );

      expect(
        LeaderboardState(
          players: [
            Player(
              id: '1',
              initials: 'AAA',
              score: 100,
              streak: 2,
              mascot: Mascot.dash,
            ),
          ],
        ),
        isNot(equals(LeaderboardState())),
      );
    });

    group('copyWith', () {
      test('updates status', () {
        expect(
          LeaderboardState().copyWith(status: LeaderboardStatus.success),
          equals(LeaderboardState(status: LeaderboardStatus.success)),
        );
      });

      test('updates players', () {
        expect(
          LeaderboardState().copyWith(
            players: [
              Player(
                id: '1',
                initials: 'AAA',
                score: 100,
                streak: 2,
                mascot: Mascot.dash,
              ),
            ],
          ),
          equals(
            LeaderboardState(
              players: [
                Player(
                  id: '1',
                  initials: 'AAA',
                  score: 100,
                  streak: 2,
                  mascot: Mascot.dash,
                ),
              ],
            ),
          ),
        );
      });
    });
  });
}
