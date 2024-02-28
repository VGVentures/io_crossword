import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template point_converter}
/// A converter that converts a [Point] to a [Map] and vice versa.
/// {@endtemplate}
class PointConverter extends JsonConverter<Point<int>, Map<String, dynamic>> {
  /// {@macro point_converter}
  const PointConverter();

  @override
  Point<int> fromJson(Map<String, dynamic> json) {
    return Point<int>(
      json['x'] as int,
      json['y'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(Point<int> object) {
    return {
      'x': object.x,
      'y': object.y,
    };
  }
}
