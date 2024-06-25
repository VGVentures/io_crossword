import 'package:board_generator/board_generator.dart';
import 'package:equatable/equatable.dart';

/// A set of bounds that define a rectangular region in the crossword puzzle.
class Bounds extends Equatable {
  /// Creates a new [Bounds] with the provided [topLeft] and [bottomRight]
  const Bounds.fromTLBR({
    required this.topLeft,
    required this.bottomRight,
  });

  /// Creates a new [Bounds] with the provided [size].
  ///
  /// The center is [Location.zero].
  ///
  /// If the [size] is odd, it will be rounded down.
  Bounds.square({required int size})
      : this.fromTLBR(
          topLeft: Location(x: -size ~/ 2, y: -size ~/ 2),
          bottomRight: Location(x: size ~/ 2, y: size ~/ 2),
        );

  /// The top-left corner of the bounds.
  final Location topLeft;

  /// The bottom-right corner of the bounds.
  final Location bottomRight;

  /// The width of the bounds.
  int get width => bottomRight.x - topLeft.x;

  /// The height of the bounds.
  int get height => bottomRight.y - topLeft.y;

  /// Whether the bounds contain the provided [location] or not.
  bool contains(Location location) {
    return location.x >= topLeft.x &&
        location.x <= bottomRight.x &&
        location.y >= topLeft.y &&
        location.y <= bottomRight.y;
  }

  @override
  List<Object?> get props => [topLeft, bottomRight];
}
