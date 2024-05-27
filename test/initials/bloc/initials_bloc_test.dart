import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:mocktail/mocktail.dart';

class _MockLeaderboardResource extends Mock implements LeaderboardResource {}

void main() {
  group('$InitialsBloc', () {
    late LeaderboardResource leaderboardResource;

    setUp(() {
      leaderboardResource = _MockLeaderboardResource();
    });

    group('$InitialsBlocklistRequested', () {
      blocTest<InitialsBloc, InitialsState>(
        'updates blocklist when request is successful',
        build: () => InitialsBloc(leaderboardResource: leaderboardResource),
        act: (bloc) {
          when(() => leaderboardResource.getInitialsBlacklist())
              .thenAnswer((_) async => ['AAA', 'BBB']);
          bloc.add(const InitialsBlocklistRequested());
        },
        expect: () => [
          isA<InitialsState>().having(
            (state) => state.initials,
            'initials',
            equals(
              InitialsInput.pure(
                '',
                blocklist: Blocklist({'AAA', 'BBB'}),
              ),
            ),
          ),
        ],
      );

      blocTest<InitialsBloc, InitialsState>(
        'does nothing when request fails',
        build: () => InitialsBloc(leaderboardResource: leaderboardResource),
        act: (bloc) {
          when(() => leaderboardResource.getInitialsBlacklist())
              .thenThrow(Exception('oops'));
          bloc.add(const InitialsBlocklistRequested());
        },
        expect: () => <InitialsState>[],
      );

      blocTest<InitialsBloc, InitialsState>(
        'does nothing when blocklist is already set',
        build: () => InitialsBloc(leaderboardResource: leaderboardResource),
        act: (bloc) {
          when(() => leaderboardResource.getInitialsBlacklist())
              .thenAnswer((_) async => ['AAA']);
          bloc
            ..add(const InitialsBlocklistRequested())
            ..add(const InitialsBlocklistRequested());
        },
        expect: () => [
          isA<InitialsState>().having(
            (state) => state.initials,
            'initials',
            equals(
              InitialsInput.pure(
                '',
                blocklist: Blocklist({'AAA'}),
              ),
            ),
          ),
        ],
      );
    });

    group('$InitialsSubmitted', () {
      blocTest<InitialsBloc, InitialsState>(
        'updates initials when submitted',
        build: () => InitialsBloc(leaderboardResource: leaderboardResource),
        act: (bloc) {
          bloc.add(const InitialsSubmitted('ABC'));
        },
        expect: () => [
          isA<InitialsState>().having(
            (state) => state.initials,
            'initials',
            equals(
              InitialsInput.dirty('ABC'),
            ),
          ),
        ],
      );

      blocTest<InitialsBloc, InitialsState>(
        'updates initials when submitted twice',
        build: () => InitialsBloc(leaderboardResource: leaderboardResource),
        act: (bloc) {
          bloc
            ..add(const InitialsSubmitted('ABC'))
            ..add(const InitialsSubmitted('ABC'));
        },
        expect: () => [
          isA<InitialsState>().having(
            (state) => state.initials,
            'initials',
            equals(
              InitialsInput.dirty('ABC'),
            ),
          ),
          isA<InitialsState>().having(
            (state) => state.initials,
            'initials',
            equals(
              InitialsInput.dirty('ABC'),
            ),
          ),
        ],
      );
    });
  });
}
