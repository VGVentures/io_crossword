// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:image/image.dart' as img;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCommand extends Mock implements img.Command {}

class _MockImage extends Mock implements img.Image {}

class _MockBitmapFont extends Mock implements img.BitmapFont {}

class _MockAssetResolver extends Mock implements AssetResolver {}

void main() {
  group('BoardRenderer', () {
    test('can be instantiated', () {
      expect(BoardRenderer(), isNotNull);
    });

    group('renderBoardWireframe', () {
      test('render the received words', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          parseFont: (Uint8List data) => _MockBitmapFont(),
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

        await renderer.renderBoardWireframe(words);

        expect(calls, 10);
      });

      test('render with fillRect when fill = true', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
          fillRect: (
            img.Image dst, {
            required int x1,
            required int y1,
            required int x2,
            required int y2,
            required img.Color color,
            num radius = 0,
            img.Image? mask,
            img.Channel maskChannel = img.Channel.luminance,
          }) {
            calls++;
            return dst;
          },
          parseFont: (Uint8List data) => _MockBitmapFont(),
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

        await renderer.renderBoardWireframe(words, fill: true);

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
            createImage: ({
              required width,
              required height,
              int numChannels = 4,
              img.Color? backgroundColor,
            }) =>
                image,
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
            parseFont: (Uint8List data) => _MockBitmapFont(),
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
            () => renderer.renderBoardWireframe(words),
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

      group('when rendering the letters', () {
        test('render the received words with the word letters', () async {
          final assetResolver = _MockAssetResolver();
          when(assetResolver.resolveFont).thenAnswer((_) async => Uint8List(0));
          final command = _MockCommand();
          final image = _MockImage();

          var calls = 0;
          var charCalls = 0;

          final renderer = BoardRenderer(
            createCommand: () => command,
            createImage: ({
              required width,
              required height,
              int numChannels = 4,
              img.Color? backgroundColor,
            }) =>
                image,
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
            drawChar: (
              img.Image image,
              String char, {
              required img.BitmapFont font,
              required int x,
              required int y,
            }) {
              charCalls++;
              return image;
            },
            parseFont: (Uint8List data) => _MockBitmapFont(),
            assetResolver: assetResolver,
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

          await renderer.renderBoardWireframe(
            words,
            addLetters: true,
          );

          expect(calls, 10);
          expect(charCalls, 10);
        });
      });
    });

    group('renderSection', () {
      late AssetResolver assetResolver;

      setUp(() {
        assetResolver = _MockAssetResolver();
        when(assetResolver.resolveWordImage)
            .thenAnswer((_) async => Uint8List(0));
      });

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
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
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
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(() => assetResolver.resolveWordImage())
            .thenThrow(AssetResolutionFailure('Failed to get image'));

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await expectLater(
          () => renderer.renderSection(section),
          throwsA(
            isA<AssetResolutionFailure>().having(
              (e) => e.toString(),
              'message',
              '[AssetResolutionFailure]: Failed to get image',
            ),
          ),
        );
      });

      test('throws when decoding the texture fails', () async {
        final command = _MockCommand();
        final image = _MockImage();

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
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
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
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

    group('groupSections', () {
      late AssetResolver assetResolver;

      setUp(() {
        assetResolver = _MockAssetResolver();
        when(assetResolver.resolveWordImage)
            .thenAnswer((_) async => Uint8List(0));
      });

      final section1 = BoardSection(
        id: '',
        position: Point(1, 1),
        size: 10,
        words: [
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
        ],
        borderWords: const [],
      );

      final section2 = BoardSection(
        id: '',
        position: Point(2, 1),
        size: 10,
        words: [
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
        ],
        borderWords: const [],
      );

      final section3 = BoardSection(
        id: '',
        position: Point(1, 2),
        size: 10,
        words: [
          Word(
            position: Point(18, 22),
            axis: Axis.horizontal,
            answer: 'hello',
            clue: '',
            hints: const [],
            solvedTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
          Word(
            position: Point(10, 21),
            axis: Axis.vertical,
            answer: 'there',
            clue: '',
            hints: const [],
            solvedTimestamp: null,
          ),
        ],
        borderWords: const [],
      );

      final section4 = BoardSection(
        id: '',
        position: Point(2, 2),
        size: 10,
        words: [
          Word(
            position: Point(28, 12),
            axis: Axis.horizontal,
            answer: 'hello',
            clue: '',
            hints: const [],
            solvedTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
          Word(
            position: Point(20, 11),
            axis: Axis.vertical,
            answer: 'there',
            clue: '',
            hints: const [],
            solvedTimestamp: null,
          ),
        ],
        borderWords: const [],
      );

      final sectionWithNoNeighbor = BoardSection(
        id: '',
        position: Point(4, 9),
        size: 10,
        words: [
          Word(
            position: Point(28, 12),
            axis: Axis.horizontal,
            answer: 'hello',
            clue: '',
            hints: const [],
            solvedTimestamp: DateTime.now().millisecondsSinceEpoch,
          ),
          Word(
            position: Point(20, 11),
            axis: Axis.vertical,
            answer: 'there',
            clue: '',
            hints: const [],
            solvedTimestamp: null,
          ),
        ],
        borderWords: const [],
      );

      test('render the received sections and group them', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await renderer.groupSections(
          [
            section1,
            section2,
            section3,
            section4,
          ],
        );

        expect(calls, 21);
      });

      test('throws when trying to render sections without neighbors', () async {
        final command = _MockCommand();
        final image = _MockImage();

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await expectLater(
          () => renderer.groupSections(
            [
              section1,
              section2,
              section3,
              section4,
              sectionWithNoNeighbor,
            ],
          ),
          throwsA(
            isA<BoardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[BoardRendererFailure]: Section Point(4, 9) has no neighbor',
            ),
          ),
        );
      });

      test('throws when decoding an image fails', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;
        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          decodePng: (Uint8List data) => (calls++ == 0 ? _MockImage() : null),
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await expectLater(
          () => renderer.groupSections(
            [
              section1,
              section2,
              section3,
              section4,
            ],
          ),
          throwsA(
            isA<BoardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[BoardRendererFailure]: Failed to decode the section image',
            ),
          ),
        );
      });

      test('throws when the image generation fails', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenAnswer((_) {
          calls++;

          if (calls == 5) {
            return null;
          } else {
            return Uint8List(0);
          }
        });

        await expectLater(
          () => renderer.groupSections(
            [
              section1,
              section2,
              section3,
              section4,
            ],
          ),
          throwsA(
            isA<BoardRendererFailure>().having(
              (e) => e.toString(),
              'message',
              '[BoardRendererFailure]: Failed to render the section group',
            ),
          ),
        );
      });
    });

    group('renderWords', () {
      late AssetResolver assetResolver;

      setUp(() {
        assetResolver = _MockAssetResolver();
        when(assetResolver.resolveWordImage)
            .thenAnswer((_) async => Uint8List(0));
      });

      final words = [
        Word(
          position: Point(18, 12),
          axis: Axis.horizontal,
          answer: 'hello',
          clue: '',
          hints: const [],
          solvedTimestamp: DateTime.now().millisecondsSinceEpoch,
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

      test('render the received words', () async {
        final command = _MockCommand();
        final image = _MockImage();

        var calls = 0;

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await renderer.renderWords(words);

        expect(calls, 10);
      });

      test("throws when can't get the texture", () async {
        final command = _MockCommand();
        final image = _MockImage();

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(() => assetResolver.resolveWordImage())
            .thenThrow(AssetResolutionFailure('Failed to get image'));

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await expectLater(
          () => renderer.renderWords(words),
          throwsA(
            isA<AssetResolutionFailure>().having(
              (e) => e.toString(),
              'message',
              '[AssetResolutionFailure]: Failed to get image',
            ),
          ),
        );
      });

      test('throws when decoding the texture fails', () async {
        final command = _MockCommand();
        final image = _MockImage();

        final renderer = BoardRenderer(
          createCommand: () => command,
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(Uint8List(0));

        await expectLater(
          () => renderer.renderWords(words),
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
          createImage: ({
            required width,
            required height,
            int numChannels = 4,
            img.Color? backgroundColor,
          }) =>
              image,
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
          assetResolver: assetResolver,
          parseFont: (Uint8List data) => _MockBitmapFont(),
        );

        when(command.execute).thenAnswer((_) async => command);
        when(() => command.outputBytes).thenReturn(null);

        await expectLater(
          () => renderer.renderWords(words),
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
