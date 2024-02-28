// ignore_for_file: prefer_const_constructors

import 'package:game_domain/game_domain.dart';
import 'package:test/test.dart';

void main() {
  group('PointConverter', () {
    test('creates correct json object from Point object', () {
      final point = Point(1, 2);
      final json = PointConverter().toJson(point);
      expect(json, equals({'x': 1, 'y': 2}));
    });

    test('creates correct Point object from json object', () {
      final json = {'x': 1, 'y': 2};
      final point = PointConverter().fromJson(json);
      expect(point, equals(Point(1, 2)));
    });
  });
}
