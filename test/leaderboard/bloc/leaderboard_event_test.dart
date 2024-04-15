// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';

void main() {
  group('$LeaderboardEvent', () {
    group('$LoadRequestedLeaderboardEvent', () {
      test('updates status', () {
        expect(
          LoadRequestedLeaderboardEvent(userId: 'user-id'),
          equals(LoadRequestedLeaderboardEvent(userId: 'user-id')),
        );

        expect(
          LoadRequestedLeaderboardEvent(userId: 'user-id'),
          isNot(equals(LoadRequestedLeaderboardEvent(userId: 'user-id-1'))),
        );
      });
    });
  });
}
