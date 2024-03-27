import 'package:equatable/equatable.dart';

///{@template location}
/// A location in the crossword puzzle.
/// {@endtemplate}
final class Location extends Equatable {
  ///{@macro location}
  const Location({
    required this.x,
    required this.y,
  });

  /// A location with the x and y values set to 0.
  static const zero = Location(x: 0, y: 0);

  /// The coordinate of the location.
  final int x;

  /// The vertical part of the location.
  final int y;

  /// Moves `this` to the left by the given [units].
  Location left([int units = 1]) => copyWith(x: x - units);

  /// Moves `this` to the right by the given [units].
  Location right([int units = 1]) => copyWith(x: x + units);

  /// Moves `this` up by the given [units].
  Location up([int units = 1]) => copyWith(y: y - units);

  /// Moves `this` down by the given [units].
  Location down([int units = 1]) => copyWith(y: y + units);

  /// Shifts `this` by the given [x] and [y] values.
  Location shift({int x = 0, int y = 0}) =>
      copyWith(x: this.x + x, y: this.y + y);

  /// Finds all the locations between `this` and [target], inclusive.
  Set<Location> to(Location target) {
    final locations = <Location>{};

    final fromX = x > target.x ? x : target.x;
    final toX = x < target.x ? x : target.x;
    final fromY = y > target.y ? y : target.y;
    final toY = y < target.y ? y : target.y;

    for (var i = toX; i <= fromX; i++) {
      for (var j = toY; j <= fromY; j++) {
        locations.add(Location(x: i, y: j));
      }
    }
    return locations;
  }

  /// Creates a new [Location] with the same values as this location.
  Location copyWith({
    int? x,
    int? y,
  }) {
    return Location(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [x, y];
}
