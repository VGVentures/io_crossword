// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:image/image.dart' as img;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

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
            visible: true,
            solvedTimestamp: null,
          ),
          Word(
            position: Point(2, 7),
            axis: Axis.vertical,
            answer: 'there',
            clue: '',
            hints: const [],
            visible: true,
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
              visible: true,
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
  });
}
