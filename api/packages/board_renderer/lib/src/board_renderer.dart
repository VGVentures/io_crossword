import 'dart:math' as math;
import 'dart:typed_data';
import 'package:game_domain/game_domain.dart';
import 'package:image/image.dart' as img;

/// A function that creates a command to execute.
typedef CreateCommand = img.Command Function();

/// A function that creates an image.
typedef CreateImage = img.Image Function({
  required int width,
  required int height,
});

/// A function that draws a rectangle in an image.
typedef DrawRect = img.Image Function(
  img.Image dst, {
  required int x1,
  required int y1,
  required int x2,
  required int y2,
  required img.Color color,
  num thickness,
  num radius,
  img.Image? mask,
  img.Channel maskChannel,
});

/// {@template board_renderer_failure}
/// Exception thrown when a board rendering fails.
/// {@endtemplate}
class BoardRendererFailure implements Exception {
  /// {@macro board_renderer_failure}
  BoardRendererFailure(this.message);

  /// Message describing the failure.
  final String message;

  @override
  String toString() => '[BoardRendererFailure]: $message';
}

/// {@template board_renderer}
/// Renders the board in images
/// {@endtemplate}
class BoardRenderer {
  /// {@macro board_renderer}
  const BoardRenderer({
    CreateCommand createCommand = img.Command.new,
    CreateImage createImage = img.Image.new,
    DrawRect drawRect = img.drawRect,
  })  : _createCommand = createCommand,
        _createImage = createImage,
        _drawRect = drawRect;

  final CreateCommand _createCommand;
  final CreateImage _createImage;
  final DrawRect _drawRect;

  /// The size of each cell in the board.
  static const cellSize = 4;

  /// Renders the full board in a single image.
  Future<Uint8List> renderBoard(List<Word> words) async {
    var minPositionX = 0;
    var minPositionY = 0;

    var maxPositionX = 0;
    var maxPositionY = 0;

    final color = img.ColorRgb8(255, 255, 255);

    for (final word in words) {
      minPositionX = math.min(minPositionX, word.position.x);
      minPositionY = math.min(minPositionY, word.position.y);

      final sizeX = word.axis == Axis.horizontal
          ? word.position.x + word.answer.length
          : word.position.x;

      final sizeY = word.axis == Axis.vertical
          ? word.position.y + word.answer.length
          : word.position.y;

      maxPositionX = math.max(maxPositionX, word.position.x + sizeX);
      maxPositionY = math.max(maxPositionY, word.position.y + sizeY);
    }

    final totalWidth = (maxPositionX + minPositionX.abs()) * cellSize;
    final totalHeight = (maxPositionY + minPositionY.abs()) * cellSize;

    final centerX = (totalWidth / 2).round();
    final centerY = (totalHeight / 2).round();

    final image = _createImage(
      width: totalWidth + cellSize,
      height: totalHeight + cellSize,
    );

    for (final word in words) {
      final wordPosition = (
        word.position.x * cellSize,
        word.position.y * cellSize,
      );

      final isHorizontal = word.axis == Axis.horizontal;
      final wordCharacters = word.answer.split('');

      for (var i = 0; i < wordCharacters.length; i++) {
        _drawRect(
          image,
          x1: (isHorizontal
                  ? wordPosition.$1 + i * cellSize
                  : wordPosition.$1) +
              centerX,
          y1: (isHorizontal
                  ? wordPosition.$2
                  : wordPosition.$2 + i * cellSize) +
              centerY,
          x2: (isHorizontal
                  ? wordPosition.$1 + i * cellSize + cellSize
                  : wordPosition.$1 + cellSize) +
              centerX,
          y2: (isHorizontal
                  ? wordPosition.$2 + cellSize
                  : wordPosition.$2 + i * cellSize + cellSize) +
              centerY,
          color: color,
        );
      }
    }

    final createdCommand = _createCommand()
      ..image(image)
      ..encodePng();

    await createdCommand.execute();

    final outputBytes = createdCommand.outputBytes;
    if (outputBytes == null) {
      throw BoardRendererFailure('Failed to render the board');
    }

    return outputBytes;
  }
}
