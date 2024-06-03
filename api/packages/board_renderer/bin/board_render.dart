// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:board_renderer/board_renderer.dart';
import 'package:csv/csv.dart';
import 'package:game_domain/game_domain.dart';

class RenderAssetResolver with AssetResolver {
  Future<Uint8List> _getAsset(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      return file.readAsBytesSync();
    } else {
      throw Exception('File not found: $path');
    }
  }

  @override
  Future<Uint8List> resolveFont() {
    return _getAsset('assets/GoogleSans-14.ttf.zip');
  }

  @override
  Future<Uint8List> resolveWordImage() {
    return _getAsset('assets/letters.png');
  }
}

void main(List<String> args) async {
  if (args.length != 2) {
    print('Usage: dart board_render.dart <board.txt> <generated_board_name>');
    return;
  }

  final boardFile = File(args[0]);

  if (boardFile.existsSync()) {
    final boardRaw = boardFile.readAsStringSync();
    final rows = const CsvToListConverter().convert(boardRaw);

    final words = rows.map((values) {
      final x = values[0] as int;
      final y = values[1] as int;
      final answer = values[2] as String;
      final axis = values[4] == WordAxis.horizontal.name
          ? WordAxis.horizontal
          : WordAxis.vertical;
      final word = Word(
        id: '$x,$y',
        position: Point(x, y),
        axis: axis,
        answer: answer,
        clue: '',
      );

      return word;
    }).toList();

    final boardRenderer = BoardRenderer(
      assetResolver: RenderAssetResolver(),
    );

    final imageBytes = await boardRenderer.renderBoardWireframe(
      words,
      addLetters: true,
      cellSize: 12,
    );

    File(args[1]).writeAsBytesSync(imageBytes);
    print('Board image generated: ${args[1]}');
  } else {
    print('File not found: ${args[0]}');
  }
}
