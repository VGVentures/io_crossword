// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/board/full_render.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardRenderer extends Mock implements BoardRenderer {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('GET /board/full_render', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    late BoardRenderer boardRenderer;
    late Uri uri;

    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      crosswordRepository = _MockCrosswordRepository();
      boardRenderer = _MockBoardRenderer();

      when(() => request.method).thenReturn(HttpMethod.get);

      uri = _MockUri();
      when(() => request.uri).thenReturn(uri);
      when(() => uri.queryParameters).thenReturn({});
      when(() => requestContext.read<BoardRenderer>())
          .thenReturn(boardRenderer);
      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
    });

    final board1 = BoardSection(
      id: '1',
      position: const Point(1, 1),
      size: 100,
      words: [
        Word(
          id: '1',
          position: const Point(1, 1),
          axis: Axis.vertical,
          answer: 'flutter',
          clue: '',
        ),
      ],
      borderWords: const [],
    );

    final board2 = BoardSection(
      id: '2',
      position: const Point(2, 1),
      size: 100,
      words: [
        Word(
          id: '2',
          position: const Point(2, 1),
          axis: Axis.vertical,
          answer: 'firebase',
          clue: '',
        ),
      ],
      borderWords: const [],
    );

    test('returns the image of the rendered board', () async {
      when(crosswordRepository.listAllSections).thenAnswer(
        (_) async => [board1, board2],
      );

      when(
        () => boardRenderer.renderBoardWireframe(
          [
            board1.words.first,
            board2.words.first,
          ],
        ),
      ).thenAnswer((_) async {
        return Uint8List(0);
      });

      final response = await route.onRequest(requestContext);

      expect(response.statusCode, HttpStatus.ok);
    });

    test('allow cell size and add letters parameters to be passed', () async {
      when(() => uri.queryParameters).thenReturn({
        'cellSize': '8',
        'addLetters': 'true',
      });

      when(
        () => boardRenderer.renderBoardWireframe(
          [
            board1.words.first,
            board2.words.first,
          ],
          cellSize: 8,
          addLetters: true,
        ),
      ).thenAnswer((_) async {
        return Uint8List(0);
      });

      when(crosswordRepository.listAllSections).thenAnswer(
        (_) async => [board1, board2],
      );

      when(
        () => boardRenderer.renderBoardWireframe(
          [
            board1.words.first,
            board2.words.first,
          ],
        ),
      ).thenAnswer((_) async {
        return Uint8List(0);
      });

      final response = await route.onRequest(requestContext);

      expect(response.statusCode, HttpStatus.ok);
    });

    test('returns method not allowed when not a get method', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      final response = await route.onRequest(requestContext);

      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
