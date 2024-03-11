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

void main() {
  group('GET /board/full_render', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    late BoardRenderer boardRenderer;

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
      final board1 = BoardSection(
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

      final board2 = BoardSection(
        id: '2',
        position: const Point(2, 1),
        size: 100,
        words: [
          Word(
            position: const Point(2, 1),
            axis: Axis.vertical,
            answer: 'firebase',
            clue: '',
            hints: const [],
            visible: true,
            solvedTimestamp: null,
          ),
        ],
        borderWords: const [],
      );

      when(crosswordRepository.listAllSections).thenAnswer(
        (_) async => [board1, board2],
      );

      when(
        () => boardRenderer.renderBoard(
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
