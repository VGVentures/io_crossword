import 'package:flutter/material.dart';
import 'package:io_crossword/crossword/game/crossword_game.dart';

extension CharactersRectangle on Characters {
  Rect getCharacterRectangle(int index) {
    final char = elementAt(index);
    final charIndex = char.codeUnitAt(0) - 65;
    return Rect.fromLTWH(
      (charIndex * CrosswordGame.cellSize).toDouble(),
      0,
      CrosswordGame.cellSize.toDouble(),
      CrosswordGame.cellSize.toDouble(),
    );
  }
}
