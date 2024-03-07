import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
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
      when(() => request.method).thenReturn(HttpMethod.post);

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<LeaderboardRepository>())
          .thenReturn(leaderboardRepository);
    });

    test('responds with a 204 on success', () async {
      when(
        () => leaderboardRepository.addPlayerToLeaderboard(
          leaderboardPlayer: any(),
        ),
      ).thenAnswer((_) async => 'id');

      when(request.json).thenAnswer(
        (_) async => {
          'initials': 'AAA',
          'score': 10,
        },
      );

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.noContent));
    });

    test('responds with a 400 when request is invalid', () async {
      when(request.json).thenAnswer((_) async => {'test': 'test'});
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with a 400 when initials are blacklisted', () async {
      when(request.json).thenAnswer(
        (_) async => {
          'initials': 'CCC',
          'score': 10,
        },
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('responds with a 400 when lowercase initials are blacklisted',
        () async {
      when(request.json).thenAnswer(
        (_) async => {
          'initials': 'ccc',
          'scoreCardId': scoreCardId,
        },
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test("responds with a 400 when lowercase initials aren't 3 characters long",
        () async {
      when(request.json).thenAnswer(
        (_) async => {
          'initials': 'aaaa',
          'scoreCardId': scoreCardId,
        },
      );
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.badRequest));
    });

    test('allows only post methods', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}
