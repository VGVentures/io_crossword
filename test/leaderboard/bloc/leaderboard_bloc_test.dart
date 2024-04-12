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
        'emits [success] when getLeaderboardResults returns players '
        'with current user in top 10 rank',
        setUp: () {
          when(() => leaderboardRepository.getLeaderboardResults('1'))
              .thenAnswer(
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
        act: (bloc) => bloc.add(
          LoadRequestedLeaderboardEvent(userId: '1'),
        ),
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
        'emits [success] when getLeaderboardResults returns players and '
        'getPlayerRanked gets users position and information',
        setUp: () {
          when(() => leaderboardRepository.getLeaderboardResults('400'))
              .thenAnswer(
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

          when(() => leaderboardRepository.getPlayerRanked('400')).thenAnswer(
            (invocation) => Stream.value(
              (
                LeaderboardPlayer(
                  userId: '3',
                  initials: 'CCC',
                  score: 60,
                  streak: 5,
                  mascot: Mascots.sparky,
                ),
                50,
              ),
            ),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          LoadRequestedLeaderboardEvent(userId: '400'),
        ),
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
            currentPlayer: LeaderboardPlayer(
              userId: '3',
              initials: 'CCC',
              score: 60,
              streak: 5,
              mascot: Mascots.sparky,
            ),
            currentUserPosition: 50,
          ),
        ],
      );

      blocTest<LeaderboardBloc, LeaderboardState>(
        'emits [failure] when getPlayerRanked throws error',
        setUp: () {
          when(() => leaderboardRepository.getLeaderboardResults('400'))
              .thenAnswer(
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

          when(() => leaderboardRepository.getPlayerRanked('400'))
              .thenAnswer((invocation) => Stream.error(Exception()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          LoadRequestedLeaderboardEvent(userId: '400'),
        ),
        expect: () => [
          LeaderboardState(
            status: LeaderboardStatus.failure,
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
