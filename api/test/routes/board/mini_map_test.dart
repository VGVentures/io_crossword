import 'dart:io';
import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/board/mini_map.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardRenderer extends Mock implements BoardRenderer {}

class _MockFirebaseCloudStorage extends Mock implements FirebaseCloudStorage {}

class _MockUri extends Mock implements Uri {}

void main() {
  group('GET /board/mini_map', () {
    late RequestContext requestContext;
    late Request request;
    late FirebaseCloudStorage firebaseCloudStorage;
    late Uri uri;

    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      when(() => requestContext.request).thenReturn(request);

      firebaseCloudStorage = _MockFirebaseCloudStorage();

      when(() => request.method).thenReturn(HttpMethod.get);

      uri = _MockUri();
      when(() => request.uri).thenReturn(uri);
      when(() => requestContext.read<FirebaseCloudStorage>())
          .thenReturn(firebaseCloudStorage);
    });

    test('returns the image url on the firebase storage', () async {
      when(() => firebaseCloudStorage.fileUrl(any())).thenReturn('url');

      final response = await route.onRequest(requestContext);

      expect(response.statusCode, HttpStatus.movedPermanently);
      expect(response.headers['location'], 'url');
    });
  });

  group('POST /board/mini_map', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    late BoardRenderer boardRenderer;
    late FirebaseCloudStorage firebaseCloudStorage;
    late Uri uri;

    setUpAll(() {
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      crosswordRepository = _MockCrosswordRepository();
      firebaseCloudStorage = _MockFirebaseCloudStorage();
      boardRenderer = _MockBoardRenderer();

      when(() => request.method).thenReturn(HttpMethod.post);

      uri = _MockUri();
      when(() => request.uri).thenReturn(uri);
      when(() => uri.queryParameters).thenReturn({});
      when(() => requestContext.read<BoardRenderer>())
          .thenReturn(boardRenderer);
      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
      when(() => requestContext.read<FirebaseCloudStorage>())
          .thenReturn(firebaseCloudStorage);
    });

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
          solvedTimestamp: null,
        ),
      ],
      borderWords: const [],
    );

    test('returns the image url on the firebase storage', () async {
      when(crosswordRepository.listAllSections).thenAnswer(
        (_) async => [board1, board2],
      );

      when(
        () => boardRenderer.renderBoardWireframe(
          [
            board1.words.first,
            board2.words.first,
          ],
          cellSize: 4,
          fill: true,
        ),
      ).thenAnswer((_) async {
        return Uint8List(0);
      });

      when(() => firebaseCloudStorage.uploadFile(any(), any()))
          .thenAnswer((_) async => 'url');

      final response = await route.onRequest(requestContext);

      expect(response.statusCode, HttpStatus.ok);
    });
  });

  final disallowedMethods = [
    HttpMethod.delete,
    HttpMethod.head,
    HttpMethod.patch,
    HttpMethod.put,
  ];

  for (final method in disallowedMethods) {
    group('$method /board/mini_map', () {
      late RequestContext requestContext;
      late Request request;

      setUp(() {
        requestContext = _MockRequestContext();
        request = _MockRequest();
        when(() => request.method).thenReturn(method);
        when(() => requestContext.request).thenReturn(request);
      });

      test('returns 405 Method Not Allowed', () async {
        final response = await route.onRequest(requestContext);

        expect(response.statusCode, HttpStatus.methodNotAllowed);
      });
    });
  }
}
