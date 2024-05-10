// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/player/bloc/player_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('$PlayerBloc', () {
    late LeaderboardRepository leaderboardRepository;
    late LeaderboardResource leaderboardResource;
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
      leaderboardResource = _MockLeaderboardResource();

      bloc = PlayerBloc(
        leaderboardResource: leaderboardResource,
        leaderboardRepository: leaderboardRepository,
      );
    });

    group('$PlayerLoaded', () {
      blocTest<PlayerBloc, PlayerState>(
        'emits nothing when player is empty',
        setUp: () {
          when(() => leaderboardRepository.getPlayerRanked('user-id'))
              .thenAnswer((_) => Stream.value((Player.empty, 3)));
        },
        seed: PlayerState.new,
        build: () => bloc,
        act: (bloc) => bloc.add(PlayerLoaded(userId: 'user-id')),
        expect: () => <PlayerState>[],
      );

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

    group('$PlayerCreateScoreRequested', () {
      blocTest<PlayerBloc, PlayerState>(
        'emits [loading] status when player can be created',
        build: () => bloc,
        setUp: () {
          when(
            () => leaderboardResource.createScore(
              initials: 'AAA',
              mascot: Mascots.dash,
            ),
          ).thenAnswer((_) async {});
        },
        seed: () => PlayerState(
          mascot: Mascots.dash,
          player: Player(
            id: '1',
            initials: 'AAA',
            mascot: Mascots.dash,
          ),
        ),
        act: (bloc) => bloc.add(PlayerCreateScoreRequested()),
        expect: () => <PlayerState>[
          PlayerState(
            status: PlayerStatus.loading,
            mascot: Mascots.dash,
            player: Player(
              id: '1',
              initials: 'AAA',
              mascot: Mascots.dash,
            ),
          ),
        ],
        verify: (bloc) => verify(
          () => leaderboardResource.createScore(
            initials: 'AAA',
            mascot: Mascots.dash,
          ),
        ).called(1),
      );

      blocTest<PlayerBloc, PlayerState>(
        'emits [failure] status when player fails to be created',
        build: () => bloc,
        setUp: () {
          when(
            () => leaderboardResource.createScore(
              initials: 'AAA',
              mascot: Mascots.dash,
            ),
          ).thenThrow(Exception());
        },
        seed: () => PlayerState(
          mascot: Mascots.dash,
          player: Player(
            id: '1',
            initials: 'AAA',
            mascot: Mascots.dash,
          ),
        ),
        act: (bloc) => bloc.add(PlayerCreateScoreRequested()),
        expect: () => <PlayerState>[
          PlayerState(
            status: PlayerStatus.loading,
            mascot: Mascots.dash,
            player: Player(
              id: '1',
              initials: 'AAA',
              mascot: Mascots.dash,
            ),
          ),
          PlayerState(
            status: PlayerStatus.failure,
            mascot: Mascots.dash,
            player: Player(
              id: '1',
              initials: 'AAA',
              mascot: Mascots.dash,
            ),
          ),
        ],
      );

      group('does nothing', () {
        blocTest<PlayerBloc, PlayerState>(
          'when already playing',
          build: () => bloc,
          seed: () => PlayerState(
            status: PlayerStatus.playing,
            mascot: Mascots.dash,
            player: Player(
              id: '1',
              initials: 'AAA',
              mascot: Mascots.dash,
            ),
          ),
          act: (bloc) => bloc.add(PlayerCreateScoreRequested()),
          expect: () => <PlayerState>[],
        );

        blocTest<PlayerBloc, PlayerState>(
          'when loading',
          build: () => bloc,
          seed: () => PlayerState(
            status: PlayerStatus.loading,
            mascot: Mascots.dash,
            player: Player(
              id: '1',
              initials: 'AAA',
              mascot: Mascots.dash,
            ),
          ),
          act: (bloc) => bloc.add(PlayerCreateScoreRequested()),
          expect: () => <PlayerState>[],
        );

        blocTest<PlayerBloc, PlayerState>(
          'when player initials are empty',
          build: () => bloc,
          seed: () => PlayerState(
            mascot: Mascots.dash,
            player: Player(
              id: '1',
              initials: '',
              mascot: Mascots.dash,
            ),
          ),
          act: (bloc) => bloc.add(PlayerCreateScoreRequested()),
          expect: () => <PlayerState>[],
        );

        blocTest<PlayerBloc, PlayerState>(
          'when there is no mascot',
          build: () => bloc,
          seed: () => PlayerState(
            // ignore: avoid_redundant_argument_values
            mascot: null,
            player: Player(
              id: '1',
              initials: '',
              mascot: Mascots.dash,
            ),
          ),
          act: (bloc) => bloc.add(PlayerCreateScoreRequested()),
          expect: () => <PlayerState>[],
        );
      });
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
