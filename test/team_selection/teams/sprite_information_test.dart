// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

void main() {
  group('SpriteInformation', () {
    test('supports equality', () {
      final spriteInformation1 = SpriteInformation(
        path: 'path',
        rows: 16,
        columns: 5,
        stepTime: 0.042,
        width: 225,
        height: 325,
      );

      final spriteInformation2 = SpriteInformation(
        path: 'path',
        rows: 16,
        columns: 5,
        stepTime: 0.042,
        width: 225,
        height: 325,
      );

      expect(spriteInformation1, equals(spriteInformation2));
    });
  });
}
