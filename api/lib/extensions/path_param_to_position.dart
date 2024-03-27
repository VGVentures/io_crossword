/// Extension on [String] to parse position path param
extension PathParamToPosition on String {
  /// Transforms a position from [String] to [(int, int)]
  (int, int)? parseToPosition() {
    final coordsRaw = split(',');
    if (coordsRaw.length != 2) {
      return null;
    }

    final x = int.tryParse(coordsRaw[0]);
    final y = int.tryParse(coordsRaw[1]);

    if (x == null || y == null) {
      return null;
    }

    return (x, y);
  }
}
