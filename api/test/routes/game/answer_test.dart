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
          when(
            () =>
                crosswordRepository.answerWord(1, 1, 1, 1, Mascots.dash, 'sun'),
          ).thenAnswer((_) async => true);
          when(
            () => leaderboardRepository.updateScore(user.id),
          ).thenAnswer((_) async {});
          when(() => request.json()).thenAnswer(
            (_) async => {
              'sectionId': '1,1',
              'wordPosition': '1,1',
              'mascot': 'dash',
              'answer': 'sun',
            },
          );

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.ok);
          expect(await response.json(), equals({'valid': true}));
          verify(() => leaderboardRepository.updateScore(user.id)).called(1);
        },
      );

      test(
        'returns Response with valid to false and does not update score '
        'if answer is incorrect',
        () async {
          when(
            () =>
                crosswordRepository.answerWord(1, 1, 1, 1, Mascots.dash, 'sun'),
          ).thenAnswer((_) async => false);
          when(() => request.json()).thenAnswer(
            (_) async => {
              'sectionId': '1,1',
              'wordPosition': '1,1',
              'mascot': 'dash',
              'answer': 'sun',
            },
          );

          final response = await route.onRequest(requestContext);

          expect(response.statusCode, HttpStatus.ok);
          expect(await response.json(), equals({'valid': false}));
          verifyNever(() => leaderboardRepository.updateScore(user.id));
        },
      );

      test(
        'returns Response with status BadRequest if section id is invalid',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'sectionId': '00',
              'wordPosition': '1,1',
              'mascot': 'dash',
              'answer': 'android',
            },
          );

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

      test(
        'returns Response with status BadRequest if word position is invalid',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'sectionId': '1,1',
              'wordPosition': '12',
              'mascot': 'dash',
              'answer': 'android',
            },
          );

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

      test(
        'returns Response with status BadRequest if sectionId is not provided',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'wordPosition': '12',
              'mascot': 'dash',
              'answer': 'android',
            },
          );

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

      test(
        'returns Response with status BadRequest if wordPosition '
        'is not provided',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'sectionId': '1,1',
              'mascot': 'dash',
              'answer': 'android',
            },
          );

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

      test(
        'returns Response with status BadRequest if mascot is not provided',
        () async {
          when(() => request.json()).thenAnswer(
            (_) async => {
              'sectionId': '1,1',
              'wordPosition': '1,1',
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
              'sectionId': '1,1',
              'wordPosition': '1,1',
              'mascot': 'dash',
            },
          );

          final response = await route.onRequest(requestContext);
          expect(response.statusCode, HttpStatus.badRequest);
        },
      );
    });
  });
}
