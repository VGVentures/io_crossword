import 'dart:io';
import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/board/sections/[sectionId].dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardRenderer extends Mock implements BoardRenderer {}

void main() {
  group('GET /board/sections/[sectionId]', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    late BoardRenderer boardRenderer;

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
      boardRenderer = _MockBoardRenderer();

      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => requestContext.read<BoardRenderer>())
          .thenReturn(boardRenderer);
      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
    });

    test('returns the image of the rendered board', () async {
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
            visible: true,
            solvedTimestamp: null,
          ),
        ],
        borderWords: const [],
      );

      when(() => crosswordRepository.findSectionByPosition(0, 0)).thenAnswer(
        (_) async => section,
      );

      when(
        () => boardRenderer.renderSection(section),
      ).thenAnswer((_) async {
        return Uint8List(0);
      });

      final response = await route.onRequest(requestContext, '0,0');

      expect(response.statusCode, HttpStatus.ok);
    });

    test('returns 404 when the board is not found', () async {
      when(() => crosswordRepository.findSectionByPosition(0, 0)).thenAnswer(
        (_) async => null,
      );

      when(
        () => boardRenderer.renderSection(any()),
      ).thenAnswer((_) async {
        return Uint8List(0);
      });

      final response = await route.onRequest(requestContext, '0,0');

      expect(response.statusCode, HttpStatus.notFound);
    });

    test('returns method not allowed when not a get method', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(requestContext, '0,0');

      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });

    test('returns bad request when the id is invalid', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(requestContext, 'a,0');

      expect(response.statusCode, HttpStatus.badRequest);
    });

    test('returns bad request when the id is incomplete', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      final response = await route.onRequest(requestContext, '0');

      expect(response.statusCode, HttpStatus.badRequest);
    });
  });
}
