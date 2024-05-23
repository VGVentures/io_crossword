// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:game_domain/game_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/board/sections/[sectionId]/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

class _MockBoardRenderer extends Mock implements BoardRenderer {}

class _MockFirebaseCloudStorage extends Mock implements FirebaseCloudStorage {}

void main() {
  group('/board/sections/[sectionId]', () {
    late RequestContext requestContext;
    late Request request;
    late CrosswordRepository crosswordRepository;
    late BoardRenderer boardRenderer;
    late FirebaseCloudStorage firebaseCloudStorage;

    final word = Word(
      id: '1',
      position: const Point(1, 1),
      axis: WordAxis.vertical,
      answer: 'flutter',
      clue: '',
    );

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
      registerFallbackValue(Uint8List(0));
    });

    setUp(() {
      requestContext = _MockRequestContext();
      request = _MockRequest();
      crosswordRepository = _MockCrosswordRepository();
      boardRenderer = _MockBoardRenderer();
      firebaseCloudStorage = _MockFirebaseCloudStorage();

      when(() => requestContext.request).thenReturn(request);
      when(() => requestContext.read<BoardRenderer>())
          .thenReturn(boardRenderer);
      when(() => requestContext.read<CrosswordRepository>())
          .thenReturn(crosswordRepository);
      when(() => requestContext.read<FirebaseCloudStorage>()).thenReturn(
        firebaseCloudStorage,
      );
    });

    const allowedMethods = [HttpMethod.get, HttpMethod.post];
    final notAllowedMethods = HttpMethod.values.where(
      (e) => !allowedMethods.contains(e),
    );
    for (final method in notAllowedMethods) {
      test('returns methods not allowed when method is $method', () async {
        when(() => request.method).thenReturn(method);
        final response = await route.onRequest(requestContext, '0,0');

        expect(response.statusCode, HttpStatus.methodNotAllowed);
      });
    }

    group('POST /board/sections/[sectionId]', () {
      setUp(() {
        when(() => request.method).thenReturn(HttpMethod.post);
      });

      test('uploads the image and return its url', () async {
        final section = BoardSection(
          id: '1',
          position: const Point(1, 1),
          size: 100,
          words: [
            Word(
              id: '1',
              position: const Point(1, 1),
              axis: WordAxis.vertical,
              answer: 'flutter',
              clue: '',
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

        when(
          () => firebaseCloudStorage.uploadFile(
            any(),
            any(),
          ),
        ).thenAnswer((_) async {
          return 'https://example.com/image.png';
        });

        when(
          () => crosswordRepository.updateSection(any()),
        ).thenAnswer((_) async {});

        final response = await route.onRequest(requestContext, '0,0');

        expect(response.statusCode, HttpStatus.ok);
        expect(await response.json(), {'url': 'https://example.com/image.png'});

        verify(
          () => crosswordRepository.updateSection(
            section.copyWith(snapshotUrl: 'https://example.com/image.png'),
          ),
        ).called(1);
      });

      test('uploads the group image when post to id group', () async {
        final section1 = BoardSection(
          id: '1',
          position: const Point(1, 1),
          size: 100,
          words: [word],
          borderWords: const [],
        );

        final section2 = BoardSection(
          id: '2',
          position: const Point(2, 1),
          size: 100,
          words: [word],
          borderWords: const [],
        );

        when(() => crosswordRepository.findSectionByPosition(1, 1)).thenAnswer(
          (_) async => section1,
        );

        when(() => crosswordRepository.findSectionByPosition(2, 1)).thenAnswer(
          (_) async => section2,
        );

        when(
          () => boardRenderer.groupSections([section1, section2]),
        ).thenAnswer((_) async {
          return Uint8List(0);
        });

        when(
          () => firebaseCloudStorage.uploadFile(
            any(),
            any(),
          ),
        ).thenAnswer((_) async {
          return 'https://example.com/image.png';
        });

        when(request.json).thenAnswer(
          (_) async => {
            'sections': [
              {'x': 1, 'y': 1},
              {'x': 2, 'y': 1},
            ],
          },
        );

        final response = await route.onRequest(requestContext, 'group');

        expect(response.statusCode, HttpStatus.ok);
        expect(await response.json(), {'url': 'https://example.com/image.png'});
      });

      test(
        'when posting to group, returns bad request when having an '
        'invalid body',
        () async {
          final section1 = BoardSection(
            id: '1',
            position: const Point(1, 1),
            size: 100,
            words: [word],
            borderWords: const [],
          );

          final section2 = BoardSection(
            id: '2',
            position: const Point(2, 1),
            size: 100,
            words: [word],
            borderWords: const [],
          );

          when(() => crosswordRepository.findSectionByPosition(1, 1))
              .thenAnswer(
            (_) async => section1,
          );

          when(() => crosswordRepository.findSectionByPosition(2, 1))
              .thenAnswer(
            (_) async => section2,
          );

          when(
            () => boardRenderer.groupSections([section1, section2]),
          ).thenAnswer((_) async {
            return Uint8List(0);
          });

          when(
            () => firebaseCloudStorage.uploadFile(
              any(),
              any(),
            ),
          ).thenAnswer((_) async {
            return 'https://example.com/image.png';
          });

          when(request.json).thenAnswer(
            (_) async => {
              'sections': [
                {'x': 1, 'z': 1},
                {'x': 2, 'A': 1},
              ],
            },
          );

          final response = await route.onRequest(requestContext, 'group');

          expect(response.statusCode, HttpStatus.badRequest);
        },
      );

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

      test('returns bad request when the id is invalid', () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        final response = await route.onRequest(requestContext, 'a,0');

        expect(response.statusCode, HttpStatus.badRequest);
      });

      test('returns bad request when the id is incomplete', () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        final response = await route.onRequest(requestContext, '0');

        expect(response.statusCode, HttpStatus.badRequest);
      });
    });

    group('GET', () {
      setUp(() {
        when(() => request.method).thenReturn(HttpMethod.get);
        when(() => requestContext.read<BoardRenderer>())
            .thenReturn(boardRenderer);
        when(() => requestContext.request).thenReturn(request);
        when(() => requestContext.read<CrosswordRepository>())
            .thenReturn(crosswordRepository);
      });

      test('the image', () async {
        final section = BoardSection(
          id: '1',
          position: const Point(1, 1),
          size: 100,
          words: [word],
          borderWords: const [],
          snapshotUrl: 'https://example.com/image.png',
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

        expect(response.statusCode, HttpStatus.movedPermanently);
        expect(response.headers['Location'], 'https://example.com/image.png');
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
  });
}
