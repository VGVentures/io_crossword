// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/leaderboard/initials/index.dart' as route;

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockRequest extends Mock implements Request {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('POST /game/leaderboard/initials', () {
    late LeaderboardRepository leaderboardRepository;
    late Request request;
    late RequestContext context;

    const blacklist = ['CCC'];

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();

      when(() => leaderboardRepository.getInitialsBlacklist())
          .thenAnswer((_) async => blacklist);

      request = _MockRequest();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<LeaderboardRepository>())
          .thenReturn(leaderboardRepository);
    });

    test('calls addPlayerToLeaderboard with player leaderboard information',
        () async {
      final leaderboardPlayer = LeaderboardPlayer(
        userId: 'user-id',
        initials: 'AAA',
        score: 10,
        mascot: Mascots.dash,
        streak: 2,
      );

      when(
        () => leaderboardRepository.addPlayerToLeaderboard(
          leaderboardPlayer: leaderboardPlayer,
        ),
      ).thenAnswer((_) async {});

      when(() => request.method).thenReturn(HttpMethod.post);

      when(request.json).thenAnswer((_) async => leaderboardPlayer.toJson());

      await route.onRequest(context);

      verify(
        () => leaderboardRepository.addPlayerToLeaderboard(
          leaderboardPlayer: leaderboardPlayer,
        ),
      ).called(1);
    });

    test('responds with a 204 on success', () async {
      final leaderboardPlayer = LeaderboardPlayer(
        userId: 'user-id',
        initials: 'AAA',
        score: 10,
        mascot: Mascots.dash,
        streak: 2,
      );

      when(() => request.method).thenReturn(HttpMethod.post);

      when(
        () => leaderboardRepository.addPlayerToLeaderboard(
          leaderboardPlayer: leaderboardPlayer,
        ),
      ).thenAnswer((_) async {});

      when(request.json).thenAnswer((_) async => leaderboardPlayer.toJson());

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.noContent));
    });

    test('responds with a 400 when mascot is not correct', () async {
      final leaderboardPlayer = LeaderboardPlayer(
        userId: 'user-id',
        initials: 'AAA',
        score: 10,
        mascot: Mascots.dash,
        streak: 2,
      );

      when(() => request.method).thenReturn(HttpMethod.post);

      when(
        () => leaderboardRepository.addPlayerToLeaderboard(
          leaderboardPlayer: leaderboardPlayer,
        ),
      ).thenAnswer((_) async {});

      when(request.json).thenAnswer(
        (_) async => leaderboardPlayer.toJson()
          ..update('mascot', (value) => 'no-real-mascot'),
      );

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with a 400 when request is invalid', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.json).thenAnswer((_) async => {'test': 'test'});

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with a 400 when initials are blacklisted', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.json).thenAnswer(
        (_) async => {
          'userId': 'user-id',
          'initials': 'CCC',
          'score': 10,
          'mascot': 'dash',
          'streak': 2,
        },
      );

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with a 400 when lowercase initials are blacklisted',
        () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(request.json).thenAnswer(
        (_) async => {
          'userId': 'user-id',
          'initials': 'ccc',
          'score': 10,
          'mascot': 'dash',
          'streak': 2,
        },
      );

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test(
      'responds with a 400 when initials are less than 3 characters long',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(request.json).thenAnswer(
          (_) async => {
            'userId': 'user-id',
            'initials': 'aa',
            'score': 10,
            'mascot': 'dash',
            'streak': 2,
          },
        );

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
    );

    test(
      'responds with a 400 when initials are more than 3 characters long',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(request.json).thenAnswer(
          (_) async => {
            'userId': 'user-id',
            'initials': 'aaaa',
            'score': 10,
            'mascot': 'dash',
            'streak': 2,
          },
        );

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
    );

    for (final httpMethod in HttpMethod.values.toList()
      ..remove(HttpMethod.post)) {
      test('does not allow $httpMethod', () async {
        when(() => request.method).thenReturn(httpMethod);

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
    }
  });
}
