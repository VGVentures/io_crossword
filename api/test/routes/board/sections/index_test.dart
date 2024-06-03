import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../routes/board/sections/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

void main() {
  group('GET /board/sections', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      when(() => request.method).thenReturn(HttpMethod.get);

      crosswordRepository = _MockCrosswordRepository();

      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
    });

    test('return all sections', () async {
      const boardSections = [
        BoardSection(
          id: '1',
          position: Point(1, 1),
          words: [],
        ),
        BoardSection(
          id: '2',
          position: Point(2, 1),
          words: [],
        ),
      ];
      when(() => crosswordRepository.listAllSections())
          .thenAnswer((_) async => boardSections);

      final response = await route.onRequest(requestContext);
      expect(response.statusCode, HttpStatus.ok);
      expect(
        await response.json(),
        boardSections.map((section) => section.toJson()).toList(),
      );
    });

    test('returns method not allowed when is not a get', () async {
      when(() => request.method).thenReturn(HttpMethod.post);

      final response = await route.onRequest(requestContext);
      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });
}
