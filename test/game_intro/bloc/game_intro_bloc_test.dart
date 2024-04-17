// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/bloc/game_intro_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('$GameIntroBloc', () {
    late LeaderboardResource leaderboardResource;
    late GameIntroBloc bloc;

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();
      bloc = GameIntroBloc(
        leaderboardResource: leaderboardResource,
      );
    });

    group('$GameIntroPlayerCreated', () {
      blocTest<GameIntroBloc, GameIntroState>(
        'emits [inProgress, success]',
        setUp: () {
          when(
            () => leaderboardResource.createScore(
              initials: 'ABC',
              mascot: Mascots.android,
            ),
          ).thenAnswer((_) async => []);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          GameIntroPlayerCreated(
            initials: 'ABC',
            mascot: Mascots.android,
          ),
        ),
        expect: () => [
          GameIntroState(
            status: GameIntroPlayerCreationStatus.inProgress,
          ),
          GameIntroState(
            status: GameIntroPlayerCreationStatus.success,
          ),
        ],
      );

      blocTest<GameIntroBloc, GameIntroState>(
        'emits [inProgress, failure] when createScore throws exception',
        setUp: () {
          when(
            () => leaderboardResource.createScore(
              initials: 'ABC',
              mascot: Mascots.android,
            ),
          ).thenThrow(Exception());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(
          GameIntroPlayerCreated(
            initials: 'ABC',
            mascot: Mascots.android,
          ),
        ),
        expect: () => [
          GameIntroState(
            status: GameIntroPlayerCreationStatus.inProgress,
          ),
          GameIntroState(
            status: GameIntroPlayerCreationStatus.failure,
          ),
        ],
      );
    });
  });
}
