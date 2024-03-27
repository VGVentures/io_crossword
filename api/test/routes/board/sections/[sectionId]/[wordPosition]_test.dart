// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:clock/clock.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
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

    setUpAll(() {
      registerFallbackValue(
        const BoardSection(
          id: '',
          position: Point(0, 0),
          size: 10,
          words: [],
          borderWords: [],
        ),
      );
    });

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
        final section = BoardSection(
          id: '1',
          position: const Point(1, 1),
          size: 100,
          words: [
            Word(
              position: const Point(1, 1),
              axis: Axis.vertical,
              answer: 'flutter',
              clue: '',
              hints: const [],
              solvedTimestamp: null,
            ),
          ],
          borderWords: const [],
        );
        final time = DateTime.now();
        final clock = Clock.fixed(time);

        when(() => request.json()).thenAnswer(
          (_) => Future.value({'answer': 'flutter'}),
        );
        when(() => crosswordRepository.findSectionByPosition(1, 1)).thenAnswer(
          (_) async => section.copyWith(),
        );
        when(
          () => crosswordRepository.updateSection(any()),
        ).thenAnswer((_) async {});

        await withClock(clock, () async {
          final response = await route.onRequest(requestContext, '1,1', '1,1');

          expect(response.statusCode, HttpStatus.ok);
          expect(await response.json(), equals({'valid': true}));

          verify(
            () => crosswordRepository.updateSection(
              section.copyWith(
                words: [
                  Word(
                    position: const Point(1, 1),
                    axis: Axis.vertical,
                    answer: 'flutter',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: time.millisecondsSinceEpoch,
                  ),
                ],
              ),
            ),
          ).called(1);
        });
      });

      test('returns Response with valid to false if answer is incorrect',
          () async {
        final section = BoardSection(
          id: '1',
          position: const Point(1, 1),
          size: 100,
          words: [
            Word(
              position: const Point(1, 1),
              axis: Axis.vertical,
              answer: 'flutter',
              clue: '',
              hints: const [],
              solvedTimestamp: null,
            ),
          ],
          borderWords: const [],
        );
        when(() => request.json()).thenAnswer(
          (_) async => {'answer': 'android'},
        );
        when(() => crosswordRepository.findSectionByPosition(1, 1)).thenAnswer(
          (_) async => section,
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

      test(
          'returns Response with status NotFound'
          ' if section does not exist', () async {
        when(() => crosswordRepository.findSectionByPosition(1, 1)).thenAnswer(
          (_) async => null,
        );

        final response = await route.onRequest(requestContext, '1,1', '1,2');
        expect(response.statusCode, HttpStatus.notFound);
      });
    });
  });
}
