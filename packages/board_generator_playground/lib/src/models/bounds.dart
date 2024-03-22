import 'package:board_generator_playground/src/models/models.dart';
import 'package:equatable/equatable.dart';

/// A set of bounds that define a rectangular region in the crossword puzzle.
// TODO(alestiago): Consider using `Rectangle` (from dart:math) and extension
// methods instead.
class Bounds extends Equatable {
  /// Creates a new [Bounds] with the provided [topLeft] and [bottomRight]
  const Bounds.fromTLBR({
    required this.topLeft,
    required this.bottomRight,
  });

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
