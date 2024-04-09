import 'package:game_domain/game_domain.dart';

extension CharactersPosition on Word {
  Point<int> getCharactersPosition(int index) {
    final x = axis == Axis.horizontal ? position.x + index : position.x;
    final y = axis == Axis.vertical ? position.y + index : position.y;
    return Point(x, y);
  }
}
