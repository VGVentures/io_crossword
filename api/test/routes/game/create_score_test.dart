import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/game/create_score.dart' as route;

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
  });

  group('POST', () {
    test(
      'responds with a HttpStatus.created status when creating the '
      'score succeeds',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(request.json)
            .thenAnswer((_) async => {'initials': 'AAA', 'mascot': 'dash'});
        when(() => leaderboardRepository.createScore(any(), any(), any()))
            .thenAnswer((_) async {});

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.created));
      },
    );

    test(
      'responds with a HttpStatus.badRequest status when the initials '
      'or mascot parameters are missing',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(request.json).thenAnswer((_) async => {'key': 'value'});

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.badRequest));
      },
    );

    test(
      'rethrows exception if creating the score fails',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(request.json)
            .thenAnswer((_) async => {'initials': 'AAA', 'mascot': 'dash'});
        when(() => leaderboardRepository.createScore(any(), any(), any()))
            .thenThrow(Exception());

        final response = route.onRequest(context);
        expect(response, throwsA(isA<Exception>()));
      },
    );
  });

  group('Other http methods', () {
    for (final httpMethod in HttpMethod.values.toList()
      ..remove(HttpMethod.post)) {
      test('are not allowed: $httpMethod', () async {
        when(() => request.method).thenReturn(httpMethod);

        final response = await route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
      });
    }
  });
}
