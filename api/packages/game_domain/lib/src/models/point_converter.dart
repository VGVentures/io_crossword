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
      (json['x'] as num).toInt(),
      (json['y'] as num).toInt(),
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

/// {@template point_converter}
/// A converter that converts a [List] of [Point] to a [List] of [Map]
/// and vice versa.
/// {@endtemplate}
class ListPointConverter
    extends JsonConverter<List<Point<int>>, List<dynamic>> {
  /// {@macro point_converter}
  const ListPointConverter();

  @override
  List<Point<int>> fromJson(List<dynamic> json) {
    return json.map(
      (j) {
        return Point<int>(
          ((j as Map)['x'] as num).toInt(),
          (j['y'] as num).toInt(),
        );
      },
    ).toList();
  }

  @override
  List<Map<String, dynamic>> toJson(List<Point<int>> object) {
    return object
        .map(
          (o) => {
            'x': o.x,
            'y': o.y,
          },
        )
        .toList();
  }
}
