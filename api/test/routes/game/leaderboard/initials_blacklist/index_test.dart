import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/game/leaderboard/initials_blacklist/index.dart'
    as route;

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockRequest extends Mock implements Request {}

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    late LeaderboardRepository leaderboardRepository;
    late Request request;
    late RequestContext context;

    const blacklist = ['AAA', 'BBB', 'CCC'];

    setUp(() {
      leaderboardRepository = _MockLeaderboardRepository();

      request = _MockRequest();

      context = _MockRequestContext();
      when(() => context.request).thenReturn(request);
      when(() => context.read<LeaderboardRepository>())
          .thenReturn(leaderboardRepository);
    });

    test('responds with a 200', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => leaderboardRepository.getInitialsBlocklist())
          .thenAnswer((_) async => blacklist);

      final response = await route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
    });

    for (final httpMethod in HttpMethod.values.toList()
      ..remove(HttpMethod.get)) {
      test('does not allow $httpMethod', () async {
        when(() => request.method).thenReturn(httpMethod);

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
    }

    test('responds with the blacklist', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => leaderboardRepository.getInitialsBlocklist())
          .thenAnswer((_) async => blacklist);

      final response = await route.onRequest(context);

      final json = await response.json();
      expect(
        json,
        equals({
          'list': ['AAA', 'BBB', 'CCC'],
        }),
      );
    });
  });
}
