// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/board/sections/[sectionId]/[wordPosition].dart'
    as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

void main() {
  group('/board/sections/[sectionId]/[wordPosition]', () {
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

    const allowedMethods = [HttpMethod.post];
    final notAllowedMethods = HttpMethod.values.where(
      (e) => !allowedMethods.contains(e),
    );
    for (final method in notAllowedMethods) {
      test('returns methods not allowed when method is $method', () async {
        when(() => request.method).thenReturn(method);
        final response = await route.onRequest(requestContext, '0,0', '0,2');

        expect(response.statusCode, HttpStatus.methodNotAllowed);
      });
    }

    group('POST', () {
      setUp(() {
        when(() => request.method).thenReturn(HttpMethod.post);
      });

      test('returns Response with valid to true if answer is correct',
          () async {
        when(() => request.json()).thenAnswer(
          (_) => Future.value({'answer': 'flutter'}),
        );
        when(() => crosswordRepository.answerWord(1, 1, 1, 1, 'flutter'))
            .thenAnswer(
          (_) async => true,
        );
        final response = await route.onRequest(requestContext, '1,1', '1,1');

        expect(response.statusCode, HttpStatus.ok);
        expect(await response.json(), equals({'valid': true}));
      });

      test('returns Response with valid to false if answer is incorrect',
          () async {
        when(() => crosswordRepository.answerWord(1, 1, 1, 1, 'android'))
            .thenAnswer(
          (_) async => false,
        );
        when(() => request.json()).thenAnswer(
          (_) async => {'answer': 'android'},
        );

        final response = await route.onRequest(requestContext, '1,1', '1,1');

        expect(response.statusCode, HttpStatus.ok);
        expect(await response.json(), equals({'valid': false}));
      });

      test('returns Response with status BadRequest if section id is invalid',
          () async {
        final response = await route.onRequest(requestContext, '00', '1,2');
        expect(response.statusCode, HttpStatus.badRequest);
      });

      test(
          'returns Response with status BadRequest'
          ' if word position is invalid', () async {
        final response = await route.onRequest(requestContext, '0,0', '12');
        expect(response.statusCode, HttpStatus.badRequest);
      });
    });
  });
}
