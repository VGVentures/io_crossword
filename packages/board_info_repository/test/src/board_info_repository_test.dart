// ignore_for_file: prefer_const_constructors

import 'package:board_info_repository/board_info_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoardInfoRepository', () {
    test('can be instantiated', () {
      expect(BoardInfoRepository(), isNotNull);
    });
  });
}
