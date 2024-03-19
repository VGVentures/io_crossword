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
