// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/board_status/board_status.dart';

void main() {
  group('BoardStatusState', () {
    group('BoardStatusInitial', () {
      test('can be instantiated', () {
        expect(
          BoardStatusInitial(),
          isA<BoardStatusInitial>(),
        );
      });

      test('supports value comparisons', () {
        expect(
          BoardStatusInitial(),
          equals(BoardStatusInitial()),
        );
      });
    });

    group('BoardStatusInProgress', () {
      test('can be instantiated', () {
        expect(BoardStatusInProgress(), isA<BoardStatusInProgress>());
      });

      test('supports value comparisons', () {
        expect(BoardStatusInProgress(), equals(BoardStatusInProgress()));
      });
    });

    group('BoardStatusResetInProgress', () {
      test('can be instantiated', () {
        expect(BoardStatusResetInProgress(), isA<BoardStatusResetInProgress>());
      });

      test('supports value comparisons', () {
        expect(
          BoardStatusResetInProgress(),
          equals(BoardStatusResetInProgress()),
        );
      });
    });

    group('BoardStatusFailure', () {
      test('can be instantiated', () {
        expect(BoardStatusFailure(), isA<BoardStatusFailure>());
      });

      test('supports value comparisons', () {
        expect(BoardStatusFailure(), equals(BoardStatusFailure()));
      });
    });
  });
}
