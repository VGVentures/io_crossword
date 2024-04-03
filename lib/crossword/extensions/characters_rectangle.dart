import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/game/crossword_game.dart';

extension CharactersRectangle on Characters {
  Rect getCharacterRectangle(int index, Mascots? mascot) {
    final char = elementAt(index);
    final charIndex = char.codeUnitAt(0) - 65;
    return Rect.fromLTWH(
      (charIndex * CrosswordGame.cellSize).toDouble(),
      (mascot.lettersRow * CrosswordGame.cellSize).toDouble(),
      CrosswordGame.cellSize.toDouble(),
      CrosswordGame.cellSize.toDouble(),
    );
  }
}

extension MascotLetterRow on Mascots? {
  int get lettersRow => switch (this) {
        Mascots.dash => 0,
        Mascots.dino => 1,
        Mascots.sparky => 2,
        Mascots.android => 3,
        null => 0,
      };
}
