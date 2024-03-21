import 'dart:math' as math;
import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:image/image.dart' as img;

extension on List<Word> {
  (int, int) totalSize(int cellSize) {
    var minPositionX = 0;
    var minPositionY = 0;

    var maxPositionX = 0;
    var maxPositionY = 0;

    for (final word in this) {
      minPositionX = math.min(minPositionX, word.position.x);
      minPositionY = math.min(minPositionY, word.position.y);

      final sizeX = word.axis == Axis.horizontal
          ? word.position.x + word.answer.length
          : word.position.x;

      final sizeY = word.axis == Axis.vertical
          ? word.position.y + word.answer.length
          : word.position.y;

      maxPositionX = math.max(maxPositionX, sizeX);
      maxPositionY = math.max(maxPositionY, sizeY);
    }

    final totalWidth = (minPositionX - maxPositionX).abs() * cellSize;
    final totalHeight = (minPositionY - maxPositionY).abs() * cellSize;

    return (totalWidth, totalHeight);
  }
}

/// A function that creates a command to execute.
typedef CreateCommand = img.Command Function();

/// A function that creates an image.
typedef CreateImage = img.Image Function({
  required int width,
  required int height,
  int numChannels,
  img.Color backgroundColor,
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

/// A function that composites an image.
typedef CompositeImage = img.Image Function(
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
  img.BlendMode blend,
  bool linearBlend,
  bool center,
  img.Image? mask,
  img.Channel maskChannel,
});

/// A function that decodes a PNG image.
typedef DecodePng = img.Image? Function(Uint8List data);

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
    CompositeImage compositeImage = img.compositeImage,
    DecodePng decodePng = img.decodePng,
    AssetResolver assetResolver = const HttpAssetResolver(),
  })  : _createCommand = createCommand,
        _createImage = createImage,
        _drawRect = drawRect,
        _compositeImage = compositeImage,
        _decodePng = decodePng,
        _assetResolver = assetResolver;

  final CreateCommand _createCommand;
  final CreateImage _createImage;
  final DrawRect _drawRect;
  final CompositeImage _compositeImage;
  final DecodePng _decodePng;
  final AssetResolver _assetResolver;

  static const _textureCellSize = 80;

  /// Renders the full frame of the board.
  Future<Uint8List> renderBoardWireframe(List<Word> words) async {
    /// The size of each cell in the board when rendering in full size.
    const cellSize = 4;

    final color = img.ColorRgb8(255, 255, 255);

    final totalSize = words.totalSize(cellSize);
    final totalWidth = totalSize.$1;
    final totalHeight = totalSize.$2;

    final centerX = (totalWidth / 2).round();
    final centerY = (totalHeight / 2).round();

    final image = _createImage(
      width: totalWidth + cellSize,
      height: totalHeight + cellSize,
      numChannels: 4,
      backgroundColor: img.ColorRgba8(0, 255, 255, 255),
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
      ..convert(numChannels: 4, alpha: 0)
      ..encodePng();

    await createdCommand.execute();

    final outputBytes = createdCommand.outputBytes;
    if (outputBytes == null) {
      throw BoardRendererFailure('Failed to render the board');
    }

    return outputBytes;
  }

  /// Renders a section of the board in an image.
  Future<Uint8List> renderWords(List<Word> words) async {
    final totalSize = words.totalSize(_textureCellSize);

    final totalWidth = totalSize.$1;
    final totalHeight = totalSize.$2;

    final image = _createImage(
      width: totalWidth,
      height: totalHeight,
      numChannels: 4,
      backgroundColor: img.ColorRgba8(0, 255, 255, 255),
    );

    final textureImage = await _assetResolver.resolveWordImage();

    final texture = _decodePng(textureImage);
    if (texture == null) {
      throw BoardRendererFailure('Failed to load the texture');
    }

    for (final word in words) {
      final x = word.position.x;
      final y = word.position.y;

      final position = (x, y);

      final wordCharacters = word.answer.split('');

      for (var c = 0; c < wordCharacters.length; c++) {
        final char = wordCharacters.elementAt(c).toUpperCase();
        final charIndex = char.codeUnitAt(0) - 65;

        final (dstX, dstY) = (
          word.axis == Axis.horizontal
              ? (position.$1 + c) * _textureCellSize
              : position.$1 * _textureCellSize,
          word.axis == Axis.vertical
              ? (position.$2 + c) * _textureCellSize
              : position.$2 * _textureCellSize
        );
        if (dstX < totalWidth && dstY < totalHeight && dstX >= 0 && dstY >= 0) {
          final srcX = word.solvedTimestamp == null
              ? 2080
              : charIndex * _textureCellSize;

          _compositeImage(
            image,
            texture,
            dstX: dstX,
            dstY: dstY,
            dstW: _textureCellSize,
            dstH: _textureCellSize,
            srcX: srcX,
            srcY: 0,
            srcW: _textureCellSize,
            srcH: _textureCellSize,
          );
        }
      }
    }

    final createdCommand = _createCommand()
      ..image(image)
      ..encodePng();

    await createdCommand.execute();

    final outputBytes = createdCommand.outputBytes;
    if (outputBytes == null) {
      throw BoardRendererFailure('Failed to render the section');
    }

    return outputBytes;
  }

  /// Groups the sections of the board into a single image.
  Future<Uint8List> groupSections(List<BoardSection> sections) async {
    // Map the sections by their index.
    final sectionMap = {
      for (final section in sections) section.position: section,
    };

    // Check if all sections have a neighbor
    for (final section in sections) {
      final possibleIndexes = [
        section.position + const Point(-1, 0),
        section.position + const Point(1, 0),
        section.position + const Point(0, -1),
        section.position + const Point(0, 1),
      ];

      final intersection =
          sectionMap.keys.toSet().intersection(possibleIndexes.toSet());

      if (intersection.isEmpty) {
        throw BoardRendererFailure(
          'Section ${section.position} has no neighbor',
        );
      }
    }

    final indexes = sectionMap.keys.toList()
      // Sort by top to bottom, left to right
      ..sort((a, b) {
        if (a.y == b.y) {
          return a.x.compareTo(b.x);
        }
        return a.y.compareTo(b.y);
      });

    final topLeft = indexes.first;
    final bottomRight = indexes.last;

    final amountX = bottomRight.x - topLeft.x + 1;
    final amountY = bottomRight.y - topLeft.y + 1;

    final totalWidth = amountX * sections.first.size * _textureCellSize;
    final totalHeight = amountY * sections.first.size * _textureCellSize;

    final image = _createImage(
      width: totalWidth,
      height: totalHeight,
      numChannels: 4,
      backgroundColor: img.ColorRgba8(0, 255, 255, 255),
    );

    for (final section in sections) {
      final sectionImage = await renderSection(section);
      final sectionImageDecoded = _decodePng(sectionImage);

      if (sectionImageDecoded == null) {
        throw BoardRendererFailure('Failed to decode the section image');
      }

      final sectionPosition = section.position - topLeft;

      _compositeImage(
        image,
        sectionImageDecoded,
        dstX: sectionPosition.x * section.size * _textureCellSize,
        dstY: sectionPosition.y * section.size * _textureCellSize,
      );
    }
    final createdCommand = _createCommand()
      ..image(image)
      ..encodePng();

    await createdCommand.execute();

    final outputBytes = createdCommand.outputBytes;
    if (outputBytes == null) {
      throw BoardRendererFailure('Failed to render the section group');
    }

    return outputBytes;
  }

  /// Renders a section of the board in an image.
  Future<Uint8List> renderSection(BoardSection section) async {
    final words = [...section.words, ...section.borderWords];

    final totalWidth = section.size * _textureCellSize;
    final totalHeight = section.size * _textureCellSize;

    final image = _createImage(
      width: totalWidth,
      height: totalHeight,
      numChannels: 4,
      backgroundColor: img.ColorRgba8(0, 255, 255, 255),
    );

    final textureImage = await _assetResolver.resolveWordImage();

    final texture = _decodePng(textureImage);
    if (texture == null) {
      throw BoardRendererFailure('Failed to load the texture');
    }

    for (final word in words) {
      final x = word.position.x - section.position.x * section.size;
      final y = word.position.y - section.position.y * section.size;

      final position = (x, y);

      final wordCharacters = word.answer.split('');

      for (var c = 0; c < wordCharacters.length; c++) {
        final char = wordCharacters.elementAt(c).toUpperCase();
        final charIndex = char.codeUnitAt(0) - 65;

        final (dstX, dstY) = (
          word.axis == Axis.horizontal
              ? (position.$1 + c) * _textureCellSize
              : position.$1 * _textureCellSize,
          word.axis == Axis.vertical
              ? (position.$2 + c) * _textureCellSize
              : position.$2 * _textureCellSize
        );
        if (dstX < totalWidth && dstY < totalHeight && dstX >= 0 && dstY >= 0) {
          final srcX = word.solvedTimestamp == null
              ? 2080
              : charIndex * _textureCellSize;

          _compositeImage(
            image,
            texture,
            dstX: dstX,
            dstY: dstY,
            dstW: _textureCellSize,
            dstH: _textureCellSize,
            srcX: srcX,
            srcY: 0,
            srcW: _textureCellSize,
            srcH: _textureCellSize,
          );
        }
      }
    }

    final createdCommand = _createCommand()
      ..image(image)
      ..encodePng();

    await createdCommand.execute();

    final outputBytes = createdCommand.outputBytes;
    if (outputBytes == null) {
      throw BoardRendererFailure('Failed to render the section');
    }

    return outputBytes;
  }
}
