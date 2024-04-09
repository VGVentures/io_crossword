// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('$LeaderboardBloc', () {
    late LeaderboardResource leaderboardResource;
    late LeaderboardBloc bloc;

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();
      bloc = LeaderboardBloc(
        leaderboardResource: leaderboardResource,
      );
    });

    group('$LoadRequestedLeaderboardEvent', () {
      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [success] with empty players '
        'when getLeaderboardResults is empty',
        setUp: () {
          when(() => leaderboardResource.getLeaderboardResults())
              .thenAnswer((_) async => []);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(LoadRequestedLeaderboardEvent()),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.success,
            players: List.generate(
              10,
              (index) => const LeaderboardPlayer(
                userId: '',
                initials: 'AAA',
                score: 0,
                streak: 0,
                mascot: Mascots.dash,
              ),
            ),
          ),
        ],
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [success] when getLeaderboardResults returns players',
        setUp: () {
          when(() => leaderboardResource.getLeaderboardResults()).thenAnswer(
            (_) async => [
              LeaderboardPlayer(
                userId: '1',
                initials: 'AAA',
                score: 100,
                streak: 20,
                mascot: Mascots.dash,
              ),
              LeaderboardPlayer(
                userId: '2',
                initials: 'BBB',
                score: 80,
                streak: 10,
                mascot: Mascots.android,
              ),
              LeaderboardPlayer(
                userId: '3',
                initials: 'CCC',
                score: 60,
                streak: 5,
                mascot: Mascots.sparky,
              ),
            ],
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(LoadRequestedLeaderboardEvent()),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.success,
            players: [
              LeaderboardPlayer(
                userId: '1',
                initials: 'AAA',
                score: 100,
                streak: 20,
                mascot: Mascots.dash,
              ),
              LeaderboardPlayer(
                userId: '2',
                initials: 'BBB',
                score: 80,
                streak: 10,
                mascot: Mascots.android,
              ),
              LeaderboardPlayer(
                userId: '3',
                initials: 'CCC',
                score: 60,
                streak: 5,
                mascot: Mascots.sparky,
              ),
            ],
          ),
        ],
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [failure] when getLeaderboardResults throws exception',
        setUp: () {
          when(() => leaderboardResource.getLeaderboardResults())
              .thenThrow(Exception());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(LoadRequestedLeaderboardEvent()),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.failure,
          ),
        ],
      );
    });
  });
}
