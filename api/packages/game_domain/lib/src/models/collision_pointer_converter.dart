import 'package:game_domain/game_domain.dart';
import 'package:json_annotation/json_annotation.dart';

/// {@template collision_point_converter}
/// A converter that converts a Map<Point<int>, List<Word>> to a
/// [Map] and vice versa.
/// {@endtemplate}
class CollisionPointConverter
    extends JsonConverter<Map<Point<int>, List<Word>>, Map<String, dynamic>> {
  /// {@macro collision_point_converter}
  const CollisionPointConverter();

  @override
  Map<Point<int>, List<Word>> fromJson(Map<String, dynamic> json) {
    return Map<Point<int>, List<Word>>(
      (json['x'] as num).toInt(),
      (json['y'] as num).toInt(),
    );
  }

  @override
  Map<String, dynamic> toJson(Map<Point<int>, List<Word>> object) {
    final map = <String, dynamic>{};

    for (final value in object.entries) {
      final key = value.key;
      map['${key.x}-${key.y}'] = value.value;
    }

    return map;
  }
}
