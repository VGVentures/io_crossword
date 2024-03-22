import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/game/crossword_game.dart';

extension WordSize on Word {
  int get width => axis == Axis.horizontal
      ? answer.length * CrosswordGame.cellSize
      : CrosswordGame.cellSize;

  int get height => axis == Axis.vertical
      ? answer.length * CrosswordGame.cellSize
      : CrosswordGame.cellSize;
}
