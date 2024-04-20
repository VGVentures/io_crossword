// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/loading/loading.dart';

void main() {
  group('LoadingState', () {
    test('initial state', () {
      expect(
        LoadingState.initial(),
        equals(
          LoadingState(
            assetsCount: 0,
            loaded: 0,
          ),
        ),
      );
    });

    test('copyWith', () {
      expect(
        LoadingState.initial().copyWith(),
        equals(
          LoadingState(
            assetsCount: 0,
            loaded: 0,
          ),
        ),
      );
    });
  });
}
