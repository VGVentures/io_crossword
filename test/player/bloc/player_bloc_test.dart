// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  group('$PlayerBloc', () {
    late LeaderboardRepository leaderboardRepository;
    late PlayerBloc bloc;

    const player = Player(
      id: 'user-id',
      mascot: Mascots.android,
      streak: 5,
      initials: 'ABC',
      score: 1200,
    );

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();
      bloc = PlayerBloc(
        leaderboardRepository: leaderboardRepository,
      );
    });

    group('$PlayerLoaded', () {
      blocTest<PlayerBloc, PlayerState>(
        'emits [playing] with the player and ranking position',
        setUp: () {
          when(() => leaderboardRepository.getPlayerRanked('user-id'))
              .thenAnswer((_) => Stream.value((player, 3)));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(PlayerLoaded(userId: 'user-id')),
        expect: () => [
          PlayerState(
            status: PlayerStatus.playing,
            rank: 3,
            player: player,
          ),
        ],
      );

      blocTest<PlayerBloc, PlayerState>(
        'emits [failure] when getPlayerRanked throws error',
        setUp: () {
          when(() => leaderboardRepository.getPlayerRanked('user-id'))
              .thenAnswer((_) => Stream.error(Exception()));
        },
        build: () => bloc,
        act: (bloc) => bloc.add(PlayerLoaded(userId: 'user-id')),
        expect: () => [
          PlayerState(
            status: PlayerStatus.failure,
          ),
        ],
      );
    });

    group('MascotSelected', () {
      blocTest<PlayerBloc, PlayerState>(
        'emits [playing] state with the selected mascot '
        'when MascotSelected is added',
        build: () => bloc,
        seed: () => PlayerState(
          status: PlayerStatus.playing,
          rank: 50,
        ),
        act: (bloc) => bloc.add(MascotSelected(Mascots.android)),
        expect: () => <PlayerState>[
          PlayerState(
            status: PlayerStatus.playing,
            rank: 50,
            mascot: Mascots.android,
            player: Player.empty.copyWith(
              mascot: Mascots.android,
            ),
          ),
        ],
      );
    });

    group('InitialsSelected', () {
      blocTest<PlayerBloc, PlayerState>(
        'emits crossword loaded state with the initials entered '
        'when InitialsSelected is added',
        build: () => bloc,
        seed: () => PlayerState(
          status: PlayerStatus.playing,
        ),
        act: (bloc) => bloc.add(InitialsSelected('ABC')),
        expect: () => <PlayerState>[
          PlayerState(
            status: PlayerStatus.playing,
            player: Player.empty.copyWith(
              initials: 'ABC',
            ),
          ),
        ],
      );
    });
  });
}
