import 'package:flutter/material.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';

extension SectionRectangle on BoardSection {
  Rect getRectangle() {
    final startX = position.x * CrosswordGame.cellSize;
    final startY = position.y * CrosswordGame.cellSize;
    return Rect.fromLTWH(
      startX.toDouble(),
      startY.toDouble(),
      (size * CrosswordGame.cellSize).toDouble(),
      (size * CrosswordGame.cellSize).toDouble(),
    );
  }
}
