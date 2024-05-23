import 'dart:math' as math;
import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:game_domain/game_domain.dart';
import 'package:image/image.dart' as img;
import 'package:image/image.dart' hide Point;

extension on List<Word> {
  // This will return a tuple with the following values:
  // - The total width of the board
  // - The total height of the board
  // - The smallest X position of a word
  // - The smallest Y position of a word
  (int, int, int, int) totalSize(int cellSize) {
    var minPositionX = 0;
    var minPositionY = 0;

    var maxPositionX = 0;
    var maxPositionY = 0;

    for (final word in this) {
      minPositionX = math.min(minPositionX, word.position.x);
      minPositionY = math.min(minPositionY, word.position.y);

      final sizeX = word.axis == WordAxis.horizontal
          ? word.position.x + word.length
          : word.position.x;

      final sizeY = word.axis == WordAxis.vertical
          ? word.position.y + word.length
          : word.position.y;

      maxPositionX = math.max(maxPositionX, sizeX);
      maxPositionY = math.max(maxPositionY, sizeY);
    }

    final totalWidth = ((maxPositionX - minPositionX).abs() + 1) * cellSize;
    final totalHeight = ((maxPositionY - minPositionY).abs() + 1) * cellSize;

    return (totalWidth, totalHeight, minPositionX, minPositionY);
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
  num radius,
  img.Image? mask,
  img.Channel maskChannel,
});

/// Similar to [DrawRect] but fills the rectangle.
typedef FillRect = DrawRect;

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

/// Function definition to parse a [BitmapFont] from a [Uint8List] used by
/// [BoardRenderer].
typedef ParseFont = BitmapFont Function(Uint8List);

/// A function that renders a character in an image.
typedef DrawChar = img.Image Function(
  img.Image image,
  String char, {
  required img.BitmapFont font,
  required int x,
  required int y,
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
    FillRect fillRect = img.fillRect,
    DrawChar drawChar = img.drawChar,
    CompositeImage compositeImage = img.compositeImage,
    DecodePng decodePng = img.decodePng,
    ParseFont parseFont = BitmapFont.fromZip,
    AssetResolver assetResolver = const HttpAssetResolver(),
  })  : _createCommand = createCommand,
        _createImage = createImage,
        _drawRect = drawRect,
        _fillRect = fillRect,
        _drawChar = drawChar,
        _compositeImage = compositeImage,
        _decodePng = decodePng,
        _parseFont = parseFont,
        _assetResolver = assetResolver;

  final CreateCommand _createCommand;
  final CreateImage _createImage;
  final DrawRect _drawRect;
  final DrawRect _fillRect;
  final DrawChar _drawChar;
  final CompositeImage _compositeImage;
  final DecodePng _decodePng;
  final ParseFont _parseFont;
  final AssetResolver _assetResolver;

  static const _textureCellSize = 80;

  /// Renders the full frame of the board.
  Future<Uint8List> renderBoardWireframe(
    List<Word> words, {
    int cellSize = 1,
    bool addLetters = false,
    bool fill = false,
  }) async {
    final color = img.ColorRgb8(0, 0, 0);

    final totalSize = words.totalSize(cellSize);
    final totalWidth = totalSize.$1;
    final totalHeight = totalSize.$2;

    final centerX = (totalWidth / 2).floor();
    final centerY = (totalHeight / 2).floor();

    final paddingX = centerX - (totalSize.$3.abs() * cellSize);
    final paddingY = centerY - (totalSize.$4.abs() * cellSize);

    final image = _createImage(
      width: totalWidth,
      height: totalHeight,
      numChannels: 4,
      backgroundColor: img.ColorRgba8(0, 255, 255, 255),
    );

    final font = addLetters
        ? (_parseFont(await _assetResolver.resolveFont())..size = cellSize - 2)
        : null;

    for (final word in words) {
      final wordPosition = (
        word.position.x * cellSize,
        word.position.y * cellSize,
      );

      final isHorizontal = word.axis == WordAxis.horizontal;
      final wordCharacters = word.answer.split('');

      for (var i = 0; i < wordCharacters.length; i++) {
        final x1 =
            (isHorizontal ? wordPosition.$1 + i * cellSize : wordPosition.$1) +
                centerX -
                paddingX;
        final y1 =
            (isHorizontal ? wordPosition.$2 : wordPosition.$2 + i * cellSize) +
                centerY -
                paddingY;

        final fn = fill ? _fillRect : _drawRect;

        fn(
          image,
          x1: x1,
          y1: y1,
          x2: (isHorizontal
                  ? wordPosition.$1 + i * cellSize + cellSize
                  : wordPosition.$1 + cellSize) +
              centerX -
              paddingX,
          y2: (isHorizontal
                  ? wordPosition.$2 + cellSize
                  : wordPosition.$2 + i * cellSize + cellSize) +
              centerY -
              paddingY,
          color: color,
        );

        if (font != null) {
          final char = wordCharacters.elementAt(i);
          final s = String.fromCharCodes(char.codeUnits);

          _drawChar(
            image,
            s,
            font: font,
            x: x1 + 2,
            y: y1 + 2,
          );
        }
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
          word.axis == WordAxis.horizontal
              ? (position.$1 + c) * _textureCellSize
              : position.$1 * _textureCellSize,
          word.axis == WordAxis.vertical
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
          word.axis == WordAxis.horizontal
              ? (position.$1 + c) * _textureCellSize
              : position.$1 * _textureCellSize,
          word.axis == WordAxis.vertical
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
