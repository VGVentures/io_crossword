// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/bloc/hint_bloc.dart';

void main() {
  group('$HintModeEntered', () {
    test('supports equality', () {
      expect(HintModeEntered(), equals(HintModeEntered()));
    });
  });

  group('$HintModeExited', () {
    test('supports equality', () {
      expect(HintModeExited(), equals(HintModeExited()));
    });
  });

  group('$HintRequested', () {
    test('supports equality', () {
      expect(
        HintRequested('is it orange?'),
        equals(HintRequested('is it orange?')),
      );
    });
  });
}
