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

  /// Finds all the locations between `this` and [target].
  ///
  /// The result `this` and [target] are inclusive.
  Set<Location> to(Location target) {
    final locations = <Location>{};
    for (var i = x; i <= target.x; i++) {
      for (var j = y; j <= target.y; j++) {
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
  List<Object?> get props => [x, y];
}
