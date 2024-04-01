// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/game/answer.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

void main() {
  group('/game/answer', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;

    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      crosswordRepository = _MockCrosswordRepository();

      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
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

      test('returns Response with valid to true if answer is correct',
          () async {
        when(() => crosswordRepository.answerWord(1, 1, 1, 1, 'flutter'))
            .thenAnswer((_) async => true);
        when(() => request.json()).thenAnswer(
          (_) async => {
            'sectionId': '1,1',
            'wordPosition': '1,1',
            'mascot': 'dash',
            'answer': 'flutter',
          },
        );

        final response = await route.onRequest(requestContext);

        expect(response.statusCode, HttpStatus.ok);
        expect(await response.json(), equals({'valid': true}));
      });

      test('returns Response with valid to false if answer is incorrect',
          () async {
        when(() => crosswordRepository.answerWord(1, 1, 1, 1, 'android'))
            .thenAnswer((_) async => false);
        when(() => request.json()).thenAnswer(
          (_) async => {
            'sectionId': '1,1',
            'wordPosition': '1,1',
            'mascot': 'dash',
            'answer': 'android',
          },
        );

        final response = await route.onRequest(requestContext);

        expect(response.statusCode, HttpStatus.ok);
        expect(await response.json(), equals({'valid': false}));
      });

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
