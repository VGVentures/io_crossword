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

  /// Returns a new [Location] that is one unit to the left of this location.
  Location left([int units = 1]) => copyWith(x: x - units);

  /// Returns a new [Location] that is one unit to the right of this location.
  Location right([int units = 1]) => copyWith(x: x + units);

  /// Returns a new [Location] that is one unit above this location.
  Location up([int units = 1]) => copyWith(y: y - units);

  /// Returns a new [Location] that is one unit below this location.
  Location down([int units = 1]) => copyWith(y: y + units);

  /// Returns a new [Location] that is shifted by the given [x] and [y] values.
  Location shift({int x = 0, int y = 0}) =>
      copyWith(x: this.x + x, y: this.y + y);

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
