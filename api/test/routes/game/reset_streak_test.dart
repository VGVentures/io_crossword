// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/game/reset_streak.dart' as route;

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockRequest extends Mock implements Request {}

class _MockRequestContext extends Mock implements RequestContext {}

class _MockLogger extends Mock implements Logger {}

void main() {
  late LeaderboardRepository leaderboardRepository;
  late Request request;
  late RequestContext context;
  late Logger logger;

  setUp(() {
    leaderboardRepository = _MockLeaderboardRepository();
    request = _MockRequest();
    logger = _MockLogger();

    context = _MockRequestContext();
    when(() => context.request).thenReturn(request);
    when(() => context.read<LeaderboardRepository>())
        .thenReturn(leaderboardRepository);
    when(() => context.read<Logger>()).thenReturn(logger);
    when(() => context.read<AuthenticatedUser>())
        .thenReturn(AuthenticatedUser('id'));
  });

  for (final method in HttpMethod.values.toList()..remove(HttpMethod.post)) {
    test(
      'responds with a ${HttpStatus.methodNotAllowed} status with $method',
      () async {
        when(() => request.method).thenReturn(method);
        when(() => leaderboardRepository.resetStreak('id'))
            .thenAnswer((_) async {});

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      },
    );
  }

  group('POST', () {
    test(
      'responds with a HttpStatus.created status when reset is correct',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => leaderboardRepository.resetStreak('id'))
            .thenAnswer((_) async {});

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.ok));
      },
    );

    test(
      'calls resetStreak with the user id',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => leaderboardRepository.resetStreak('id'))
            .thenAnswer((_) async {});

        await route.onRequest(context);

        verify(() => leaderboardRepository.resetStreak('id')).called(1);
      },
    );

    test(
      'throws error when resetStreak throws exception',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => leaderboardRepository.resetStreak('id'))
            .thenThrow(Exception());

        final response = route.onRequest(context);
        expect(response, throwsA(isA<Exception>()));
      },
    );
  });
}
