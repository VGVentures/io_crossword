// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/board_status/board_status.dart';

void main() {
  group('BoardStatusEvent', () {
    group('$BoardStatusRequested', () {
      test('can be instantiated', () {
        expect(
          BoardStatusRequested(),
          isA<BoardStatusRequested>(),
        );
      });

      test('supports value comparisons', () {
        expect(
          BoardStatusRequested(),
          equals(BoardStatusRequested()),
        );
      });
    });
  });
}
