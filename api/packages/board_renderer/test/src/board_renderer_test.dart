// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockResponse extends Mock implements Response {}

class _MockCommand extends Mock implements img.Command {}

class _MockImage extends Mock implements img.Image {}

void main() {
  group('BoardRenderer', () {
    test('can be instantiated', () {
      expect(BoardRenderer(), isNotNull);
    });

    group('renderBoard', () {
      test('render the received letters', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({required width, required height}) => image,
          drawRect: (
            img.Image dst, {
            required int x1,
            required int y1,
            required int x2,
            required int y2,
            required img.Color color,
            num thickness = 0,
            num radius = 0,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            calls++;
            return dst;
          },
        );

        final words = [
          Word(
            position: Point(1, 1),
            axis: Axis.horizontal,
            answer: 'hello',
            clue: '',
            hints: const [],
            solvedTimestamp: null,
          ),
          Word(
            position: Point(2, 7),
            axis: Axis.vertical,
            answer: 'there',
            clue: '',
            hints: const [],
            solvedTimestamp: null,
          ),
        ];

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await renderer.renderBoard(words);

        expect(calls, 10);
      });

      test(
        'throws BoardRendererFailure when the command returns '
        'null bytes',
        () async {
          final command = _MockCommand();
          final image = _MockImage();

          final renderer = BoardRenderer(
            createCommand: () => command,
            createImage: ({required width, required height}) => image,
            drawRect: (
              img.Image dst, {
              required int x1,
              required int y1,
              required int x2,
              required int y2,
              required img.Color color,
              num thickness = 0,
              num radius = 0,
              img.Image? mask,
              img.Channel maskChannel = img.Channel.luminance,
            }) {
              return dst;
            },
          );

          final words = [
            Word(
              position: Point(1, 1),
              axis: Axis.horizontal,
              answer: 'hello',
              clue: '',
              hints: const [],
              solvedTimestamp: null,
            ),
          ];

          when(command.execute).thenAnswer((_) async => command);
          when(() => command.outputBytes).thenReturn(null);

          await expectLater(
            () => renderer.renderBoard(words),
            throwsA(
              isA<BoardRendererFailure>().having(
                (e) => e.toString(),
                'message',
                '[BoardRendererFailure]: Failed to render the board',
              ),
            ),
          );
        },
      );
    });

    group('renderSection', () {
      final words = [
        Word(
          position: Point(18, 12),
          axis: Axis.horizontal,
          answer: 'hello',
          clue: '',
          hints: const [],
          solvedTimestamp: null,
        ),
        Word(
          position: Point(10, 11),
          axis: Axis.vertical,
          answer: 'there',
          clue: '',
          hints: const [],
          solvedTimestamp: null,
        ),
      ];

      final section = BoardSection(
        id: '',
        position: Point(1, 1),
        size: 10,
        words: words,
        borderWords: words,
      );

      test('render the received section words', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({required width, required height}) => image,
          drawRect: (
            img.Image dst, {
            required int x1,
            required int y1,
            required int x2,
            required int y2,
            required img.Color color,
            num thickness = 0,
            num radius = 0,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            return dst;
          },
          compositeImage: (
            img.Image dst,
            img.Image src, {
            int? dstX,
            int? dstY,
            int? dstW,
            int? dstH,
            int? srcX,
            int? srcY,
            int? srcW,
            int? srcH,
            img.BlendMode blend = img.BlendMode.direct,
            bool linearBlend = false,
            bool center = false,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            calls++;
            return dst;
          },
          decodePng: (Uint8List data) => _MockImage(),
          get: (_) async {
            final response = _MockResponse();

            when(() => response.statusCode).thenReturn(200);
            when(() => response.bodyBytes).thenReturn(Uint8List(0));

            return response;
          },
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await renderer.renderSection(section);

        expect(calls, 14);
      });

      test("throws when can't get the texture", () async {
        final command = _MockCommand();
        final image = _MockImage();

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({required width, required height}) => image,
          drawRect: (
            img.Image dst, {
            required int x1,
            required int y1,
            required int x2,
            required int y2,
            required img.Color color,
            num thickness = 0,
            num radius = 0,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            return dst;
          },
          compositeImage: (
            img.Image dst,
            img.Image src, {
            int? dstX,
            int? dstY,
            int? dstW,
            int? dstH,
            int? srcX,
            int? srcY,
            int? srcW,
            int? srcH,
            img.BlendMode blend = img.BlendMode.direct,
            bool linearBlend = false,
            bool center = false,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            return dst;
          },
          decodePng: (Uint8List data) => _MockImage(),
          get: (_) async {
            final response = _MockResponse();

            when(() => response.statusCode).thenReturn(500);

            return response;
          },
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await expectLater(
          () => renderer.renderSection(section),
          throwsA(
            isA<BoardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[BoardRendererFailure]: Failed to get image from http://127.0.0.1:8080/assets/letters.png',
            ),
          ),
        );
      });

      test('throws when decoding the texture fails', () async {
        final command = _MockCommand();
        final image = _MockImage();

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({required width, required height}) => image,
          drawRect: (
            img.Image dst, {
            required int x1,
            required int y1,
            required int x2,
            required int y2,
            required img.Color color,
            num thickness = 0,
            num radius = 0,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            return dst;
          },
          compositeImage: (
            img.Image dst,
            img.Image src, {
            int? dstX,
            int? dstY,
            int? dstW,
            int? dstH,
            int? srcX,
            int? srcY,
            int? srcW,
            int? srcH,
            img.BlendMode blend = img.BlendMode.direct,
            bool linearBlend = false,
            bool center = false,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            return dst;
          },
          decodePng: (Uint8List data) => null,
          get: (_) async {
            final response = _MockResponse();

            when(() => response.statusCode).thenReturn(200);
            when(() => response.bodyBytes).thenReturn(Uint8List(0));

            return response;
          },
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await expectLater(
          () => renderer.renderSection(section),
          throwsA(
            isA<BoardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[BoardRendererFailure]: Failed to load the texture',
            ),
          ),
        );
      });

      test('throws when the command returns no bytes', () async {
        final command = _MockCommand();
        final image = _MockImage();

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({required width, required height}) => image,
          drawRect: (
            img.Image dst, {
            required int x1,
            required int y1,
            required int x2,
            required int y2,
            required img.Color color,
            num thickness = 0,
            num radius = 0,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            return dst;
          },
          compositeImage: (
            img.Image dst,
            img.Image src, {
            int? dstX,
            int? dstY,
            int? dstW,
            int? dstH,
            int? srcX,
            int? srcY,
            int? srcW,
            int? srcH,
            img.BlendMode blend = img.BlendMode.direct,
            bool linearBlend = false,
            bool center = false,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            return dst;
          },
          decodePng: (Uint8List data) => _MockImage(),
          get: (_) async {
            final response = _MockResponse();

            when(() => response.statusCode).thenReturn(200);
            when(() => response.bodyBytes).thenReturn(Uint8List(0));

            return response;
          },
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(null);

        await expectLater(
          () => renderer.renderSection(section),
          throwsA(
            isA<BoardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[BoardRendererFailure]: Failed to render the section',
            ),
          ),
        );
      });
    });
  });
}
