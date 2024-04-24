// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  group('$LeaderboardBloc', () {
    late LeaderboardRepository leaderboardRepository;
    late LeaderboardBloc bloc;

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();
      bloc = LeaderboardBloc(
        leaderboardRepository: leaderboardRepository,
      );
    });

    group('$LoadRequestedLeaderboardEvent', () {
      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [success] with empty players '
        'when getLeaderboardResults is empty',
        setUp: () {
          when(() => leaderboardRepository.getLeaderboardResults('user-id'))
              .thenAnswer((_) async => []);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          LoadRequestedLeaderboardEvent(userId: 'user-id'),
        ),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.success,
            players: List.generate(
              10,
              (index) => const Player(
                id: '',
                initials: 'AAA',
                mascot: Mascots.dash,
              ),
            ),
          ),
        ],
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [success] when getLeaderboardResults returns players '
        'with the top 10 rank',
        setUp: () {
          when(() => leaderboardRepository.getLeaderboardResults('1'))
              .thenAnswer(
            (_) async => [
              Player(
                id: '1',
                initials: 'AAA',
                score: 100,
                streak: 20,
                mascot: Mascots.dash,
              ),
              Player(
                id: '2',
                initials: 'BBB',
                score: 80,
                streak: 10,
                mascot: Mascots.android,
              ),
              Player(
                id: '3',
                initials: 'CCC',
                score: 60,
                streak: 5,
                mascot: Mascots.sparky,
              ),
            ],
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          LoadRequestedLeaderboardEvent(userId: '1'),
        ),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.success,
            players: [
              Player(
                id: '1',
                initials: 'AAA',
                score: 100,
                streak: 20,
                mascot: Mascots.dash,
              ),
              Player(
                id: '2',
                initials: 'BBB',
                score: 80,
                streak: 10,
                mascot: Mascots.android,
              ),
              Player(
                id: '3',
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
          when(() => leaderboardRepository.getLeaderboardResults('user-id'))
              .thenThrow(Exception());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          LoadRequestedLeaderboardEvent(userId: 'user-id'),
        ),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.failure,
          ),
        ],
      );
    });
  });
}
