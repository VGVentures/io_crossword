// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:jwt_middleware/jwt_middleware.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/game/answer.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

void main() {
  group('/game/answer', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    late LeaderboardRepository leaderboardRepository;
    late AuthenticatedUser user;

    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      crosswordRepository = _MockCrosswordRepository();
      leaderboardRepository = _MockLeaderboardRepository();
      user = AuthenticatedUser('userId');

      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
      when(() => requestContext.read<LeaderboardRepository>())
          .thenReturn(leaderboardRepository);
      when(() => requestContext.read<AuthenticatedUser>()).thenReturn(user);
    });

    group('other http methods', () {
      const allowedMethods = [HttpMethod.post];
      final notAllowedMethods = HttpMethod.values.where(
        (e) => !allowedMethods.contains(e),
      );

      for (final method in notAllowedMethods) {
        test('are not allowed: $method', () async {
          when(() => request.method).thenReturn(method);
          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.methodNotAllowed);
        });
      }
    });

    group('POST', () {
      setUp(() {
        when(() => request.method).thenReturn(HttpMethod.post);
      });

      test(
        'returns Response with valid to true and updates score '
        'if answer is correct',
        () async {
          when(() => leaderboardRepository.getPlayer('userId')).thenAnswer(
            (_) async => Player(
              id: 'userId',
              mascot: Mascots.dash,
              initials: 'ABC',
            ),
          );
          when(
            () => crosswordRepository.updateSolvedWordsCount(),
          ).thenAnswer((_) async {});
          when(
            () => crosswordRepository.answerWord('id', Mascots.dash, 'sun'),
          ).thenAnswer((_) async => true);
          when(
            () => leaderboardRepository.updateScore(user.id),
          ).thenAnswer((_) async => 10);
          when(() => request.json()).thenAnswer(
            (_) async => {
              'wordId': 'id',
              'answer': 'sun',
            },
          );

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.ok);
          expect(await response.json(), equals({'points': 10}));
          verify(() => leaderboardRepository.updateScore(user.id)).called(1);
        },
      );

      test(
        'returns Response with 0 points and does not update score '
        'if answer is incorrect',
        () async {
          when(() => leaderboardRepository.getPlayer('userId')).thenAnswer(
            (_) async => Player(
              id: 'userId',
              mascot: Mascots.dash,
              initials: 'ABC',
            ),
          );
          when(
            () => crosswordRepository.answerWord('id', Mascots.dash, 'sun'),
          ).thenAnswer((_) async => false);
          when(() => request.json()).thenAnswer(
            (_) async => {
              'wordId': 'id',
              'answer': 'sun',
            },
          );

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.ok);
          expect(await response.json(), equals({'points': 0}));
          verifyNever(() => leaderboardRepository.updateScore(user.id));
        },
      );

      test(
        'returns Response with status internalServerError '
        'if player does not exist',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'wordId': 'id',
              'answer': 'sun',
            },
          );
          when(() => leaderboardRepository.getPlayer('userId')).thenAnswer(
            (_) async => null,
          );

          final response = await route.onRequest(requestContext);
          final body = await response.body();
          expect(body, 'Player not found for id userId');
          expect(response.statusCode, HttpStatus.internalServerError);
        },
      );

      test(
        'returns Response with status BadRequest if wordId is not provided',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'answer': 'android',
            },
          );

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

      test(
        'returns Response with status BadRequest if answer is not provided',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'wordId': 'id',
            },
          );

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

      test(
        'returns Response with status internalServerError if answerWord throws',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'wordId': 'id',
              'answer': 'sun',
            },
          );
          when(() => leaderboardRepository.getPlayer('userId')).thenAnswer(
            (_) async => Player(
              id: 'userId',
              mascot: Mascots.dash,
              initials: 'ABC',
            ),
          );
          when(
            () => crosswordRepository.answerWord('id', Mascots.dash, 'sun'),
          ).thenThrow(Exception('Oops'));

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.internalServerError);
        },
      );
    });
  });
}
