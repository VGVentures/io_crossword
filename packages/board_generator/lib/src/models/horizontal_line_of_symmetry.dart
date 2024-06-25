import 'package:board_generator/board_generator.dart';

/// {@template horizontal_line_of_symmetry}
/// An horizontal line of symmetry.
/// {@endtemplate}
class HorizontalLineOfSymmetry {
  /// {@macro horizontal_line_of_symmetry}
  const HorizontalLineOfSymmetry();

  /// Where the line of symmetry crosses the y-axis.
  static const yIntercept = 0;

  /// Wether the location is on the line of symmetry.
  bool isOn(int y) => y == yIntercept;

  /// Wether the location is above the line of symmetry.
  bool isAbove(int y) => y < yIntercept;

  /// Wether the location is below the line of symmetry.
  bool isBelow(int y) => y > yIntercept;

  /// Reflects the [entry] over the line of symmetry, returning its new starting
  /// location.
  ///
  /// For example, consider an horizontal line of symmetry at y = 0:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -3  -  -  -  -  -
  /// -2  -  -  -  -  -
  /// -1  -  -  -  -  -
  ///  0  *  *  *  *  *
  ///  1  -  -  Y  -  -
  ///  2  -  -  E  -  -
  ///  3  -  -  S  O  S
  /// ```
  ///
  /// Mirroring the entry "SOS" would return (0, -3), and mirroring the
  /// entry "YES" would return (0, -3).
  ///
  /// If new entries are added in such mirrored locations, the board's grid
  /// would be symmetrical horizontally:
  ///
  /// ```
  ///    -2 -1  0  1  2
  /// -3  -  -  P  I  N
  /// -2  -  -  O  -  -
  /// -1  -  -  N  -  -
  ///  0  *  *  *  *  *
  ///  1  -  -  Y  -  -
  ///  2  -  -  E  -  -
  ///  3  -  -  S  O  S
  /// ```
  ///
  /// Assumes the [yIntercept] is at 0.
  Location mirror(WordEntry entry) {
    switch (entry.direction) {
      case Direction.across:
        return entry.start.copyWith(y: entry.end.y * -1);
      case Direction.down:
        return entry.end.copyWith(y: entry.end.y * -1);
    }
  }
}
